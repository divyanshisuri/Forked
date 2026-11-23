// Servings.swift
// Parses, validates and formats a recipe's serving count.

import Foundation

nonisolated enum Servings {
    static let range = 1...99

    static func count(from text: String) -> Int? {
        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty, value.allSatisfy({ $0.isASCII && $0.isNumber }),
              let count = Int(value), range.contains(count) else { return nil }
        return count
    }

    static func isValid(_ text: String) -> Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || count(from: text) != nil
    }

    static func label(_ count: Int) -> String { "Serves \(count)" }
}
