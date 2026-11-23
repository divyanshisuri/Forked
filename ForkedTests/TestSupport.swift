// TestSupport.swift
// Shared helpers for unit tests: an in-memory SwiftData container, a throwaway UserDefaults suite and a temp folder.

import Foundation
import SwiftData
@testable import Forked

@MainActor
enum TestSupport {
    static func makeContainer() throws -> ModelContainer {
        let schema = Schema(versionedSchema: ForkedSchemaV3.self)
        return try ModelContainer(for: schema, configurations: ModelConfiguration(schema: schema, isStoredInMemoryOnly: true))
    }

    static func makeDefaults() -> UserDefaults {
        let name = "ForkedTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }

    static func temporaryDirectory() -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
