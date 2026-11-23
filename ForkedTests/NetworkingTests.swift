// NetworkingTests.swift
// Unit tests for TheMealDB decoding, the offline cache and Discover's loading, offline and failure states.

import Foundation
import Testing
@testable import Forked

@MainActor
struct MealDBResponseTests {
    static let json = """
    {"meals":[{"idMeal":"1","strMeal":"Test Stew","strCategory":"Beef","strCountry":"Irish",
    "strInstructions":"STEP 1\\r\\nBrown the beef.\\r\\nSTEP 2\\r\\nSimmer for 2 hours.",
    "strMealThumb":"https://example.com/stew.jpg","strIngredient1":"Beef","strMeasure1":"1 lb",
    "strIngredient2":"Carrots","strMeasure2":"  2 ","strIngredient3":"","strMeasure3":" ","strIngredient4":null}]}
    """

    @Test func decodesIngredientsStepsAndTags() throws {
        let response = try JSONDecoder().decode(MealDBResponse.self, from: Data(Self.json.utf8))
        let recipe = try #require(response.recipes.first)
        #expect(recipe.title == "Test Stew")
        #expect(recipe.ingredients == ["1 lb Beef", "2 Carrots"])
        #expect(recipe.steps == ["Brown the beef.", "Simmer for 2 hours."])
        #expect(recipe.tags == ["Beef", "Irish"])
    }

    @Test func treatsNullMealsAsNoResults() throws {
        let response = try JSONDecoder().decode(MealDBResponse.self, from: Data(#"{"meals":null}"#.utf8))
        #expect(response.recipes.isEmpty)
    }
}

@MainActor
struct DiscoverModelTests {
    @Test func loadsFromServiceAndCachesResults() async {
        let cache = DiscoverCache(directory: TestSupport.temporaryDirectory())
        let model = DiscoverModel(service: MockFeedService(delay: .zero), cache: cache)
        await model.loadFeed()
        #expect(model.phase == .loaded)
        #expect(!model.recipes.isEmpty)
        #expect(!model.isOffline)
        #expect(cache.load()?.recipes.count == model.recipes.count)
    }

    @Test func fallsBackToCacheWhenOffline() async {
        let cache = DiscoverCache(directory: TestSupport.temporaryDirectory())
        cache.save(MockFeedService.samples, at: Date(timeIntervalSince1970: 0))
        let model = DiscoverModel(service: FailingFeedService(), cache: cache)
        await model.loadFeed()
        #expect(model.phase == .loaded)
        #expect(model.isOffline)
        #expect(model.recipes.count == MockFeedService.samples.count)
        await model.search("salmon")
        #expect(model.recipes.map(\.title) == ["Herb Crusted Salmon"])
    }

    @Test func failsWhenOfflineWithNothingSaved() async {
        let model = DiscoverModel(service: FailingFeedService(), cache: DiscoverCache(directory: TestSupport.temporaryDirectory()))
        await model.loadFeed()
        guard case .failed = model.phase else {
            Issue.record("Expected a failed phase, got \(model.phase)")
            return
        }
    }
}
