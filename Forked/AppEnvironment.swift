// AppEnvironment.swift
// Reads launch arguments so UI tests can run against an in-memory store and the mock API.

import Foundation

enum AppEnvironment {
    static let uiTestingArgument = "-UITesting"
    static let mockAPIArgument = "-MockAPI"

    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains(uiTestingArgument)
    }

    static var defaults: UserDefaults {
        guard isUITesting, let testDefaults = UserDefaults(suiteName: "ForkedUITests") else { return .standard }
        return testDefaults
    }

    static func makeFeedService() -> RecipeFeedService {
        let useMock = isUITesting || ProcessInfo.processInfo.arguments.contains(mockAPIArgument)
        return useMock ? MockFeedService() : MealDBService()
    }
}
