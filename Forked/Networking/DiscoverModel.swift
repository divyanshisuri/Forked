// DiscoverModel.swift
// Loads Discover recipes from the network, tracks loading and error states, and falls back to the offline cache.

import Foundation
import Observation

@Observable
final class DiscoverModel {
    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    private(set) var recipes: [WebRecipe] = []
    private(set) var offlineSince: Date?
    private(set) var activeQuery = ""

    private let service: RecipeFeedService
    private let cache: DiscoverCache

    init(service: RecipeFeedService, cache: DiscoverCache = DiscoverCache()) {
        self.service = service
        self.cache = cache
    }

    var isOffline: Bool { offlineSince != nil }

    /// Fetches a new random set. On failure, shows the last saved set and marks the tab offline.
    func loadFeed() async {
        activeQuery = ""
        phase = .loading
        do {
            let fresh = try await service.randomFeed(count: 8)
            recipes = fresh
            offlineSince = nil
            cache.save(fresh)
            phase = .loaded
        } catch {
            useCache(filter: nil, error: error)
        }
    }

    /// Searches by name. Offline, it searches the saved set instead.
    func search(_ query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return await loadFeed() }
        activeQuery = trimmed
        phase = .loading
        do {
            recipes = try await service.search(trimmed)
            offlineSince = nil
            phase = .loaded
        } catch {
            useCache(filter: trimmed, error: error)
        }
    }

    private func useCache(filter: String?, error: Error) {
        guard let snapshot = cache.load() else {
            recipes = []
            phase = .failed(error.localizedDescription)
            return
        }
        recipes = filter.map { query in snapshot.recipes.filter { $0.title.localizedCaseInsensitiveContains(query) } } ?? snapshot.recipes
        offlineSince = snapshot.savedAt
        phase = .loaded
    }
}
