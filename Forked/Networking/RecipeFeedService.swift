// RecipeFeedService.swift
// Where Discover gets recipes from. A base class with a live TheMealDB subclass and an offline mock subclass.

import Foundation

enum FeedError: LocalizedError {
    case badResponse
    case notImplemented

    var errorDescription: String? {
        switch self {
        case .badResponse: "The recipe server sent something unexpected."
        case .notImplemented: "This feed source isn't available."
        }
    }
}

// PARADIGM: Object-oriented with inheritance. Subclasses override these methods to supply recipes.
class RecipeFeedService {
    /// A fresh set of recipes. Live sources return different recipes on every call.
    func randomFeed(count: Int) async throws -> [WebRecipe] {
        throw FeedError.notImplemented
    }

    /// Recipes whose names match the query.
    func search(_ query: String) async throws -> [WebRecipe] {
        throw FeedError.notImplemented
    }
}

/// Live data from TheMealDB's free public API. https://www.themealdb.com/api.php
final class MealDBService: RecipeFeedService {
    private let session: URLSession
    private let baseURL = URL(string: "https://www.themealdb.com/api/json/v1/1/")!

    init(session: URLSession = .shared) {
        self.session = session
    }

    override func randomFeed(count: Int) async throws -> [WebRecipe] {
        let batches = try await withThrowingTaskGroup(of: [WebRecipe].self) { group in
            for _ in 0..<count {
                group.addTask { try await self.fetch("random.php", query: []) }
            }
            return try await group.reduce(into: [WebRecipe]()) { $0 += $1 }
        }
        var seen = Set<String>()
        return batches.filter { seen.insert($0.id).inserted }
    }

    override func search(_ query: String) async throws -> [WebRecipe] {
        try await fetch("search.php", query: [URLQueryItem(name: "s", value: query)])
    }

    private func fetch(_ path: String, query: [URLQueryItem]) async throws -> [WebRecipe] {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = query.isEmpty ? nil : query
        guard let url = components?.url else { throw FeedError.badResponse }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw FeedError.badResponse
        }
        return try JSONDecoder().decode(MealDBResponse.self, from: data).recipes
    }
}

/// A mock API with simulated latency, used by UI tests and when running without a network.
final class MockFeedService: RecipeFeedService {
    private let delay: Duration

    init(delay: Duration = .milliseconds(400)) {
        self.delay = delay
    }

    static let samples: [WebRecipe] = [
        WebRecipe(id: "mock-1", title: "Herb Crusted Salmon", category: "Seafood", area: "French",
                  thumbnailURL: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&q=80",
                  instructions: "Heat the oven to 400°F.\nPress the herb crumb onto the salmon.\nRoast for 12 minutes.\nServe with the vegetables.",
                  ingredients: ["2 salmon fillets", "1/2 cup breadcrumbs", "2 tbsp chopped herbs", "1 tbsp olive oil"]),
        WebRecipe(id: "mock-2", title: "Spiced Shrimp Fried Rice", category: "Seafood", area: "Thai",
                  thumbnailURL: "https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800&q=80",
                  instructions: "Stir-fry the shrimp for 3 minutes.\nAdd the rice and spices and fry for 4 minutes.\nFinish with lemon and herbs.",
                  ingredients: ["3 cups cooked rice", "1/2 lb shrimp", "1 tsp curry powder", "1 lemon"]),
        WebRecipe(id: "mock-3", title: "Garden Salad with Feta", category: "Vegetarian", area: "Greek",
                  thumbnailURL: "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800&q=80",
                  instructions: "Toss the greens with the vegetables.\nCrumble over the feta.\nDress with olive oil and lemon.",
                  ingredients: ["4 cups mixed greens", "1/2 cup feta", "1 red onion", "2 tbsp olive oil"])
    ]

    override func randomFeed(count: Int) async throws -> [WebRecipe] {
        try await Task.sleep(for: delay)
        return Array(Self.samples.shuffled().prefix(count))
    }

    override func search(_ query: String) async throws -> [WebRecipe] {
        try await Task.sleep(for: delay)
        return Self.samples.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}

/// Always fails, used to exercise offline mode in tests.
final class FailingFeedService: RecipeFeedService {
    override func randomFeed(count: Int) async throws -> [WebRecipe] { throw URLError(.notConnectedToInternet) }
    override func search(_ query: String) async throws -> [WebRecipe] { throw URLError(.notConnectedToInternet) }
}
