// DiscoverCache.swift
// Saves the last successful Discover results to disk so the tab still works offline.

import Foundation

nonisolated struct DiscoverCache {
    struct Snapshot: Codable {
        let savedAt: Date
        let recipes: [WebRecipe]
    }

    let fileURL: URL

    init(directory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]) {
        fileURL = directory.appendingPathComponent("discover-feed.json")
    }

    // PARADIGM: Procedural. Plain save and load steps with no shared state.
    func save(_ recipes: [WebRecipe], at date: Date = .now) {
        guard !recipes.isEmpty, let data = try? JSONEncoder().encode(Snapshot(savedAt: date, recipes: recipes)) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func load() -> Snapshot? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(Snapshot.self, from: data)
    }
}
