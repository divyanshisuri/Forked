// WebRecipe.swift
// A recipe fetched from the internet, before the user saves it into their cookbook.

import Foundation

nonisolated struct WebRecipe: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let category: String?
    let area: String?
    let thumbnailURL: String?
    let instructions: String
    let ingredients: [String]

    var tags: [String] {
        [category, area].compactMap { $0 }.filter { !$0.isEmpty }
    }

    /// Splits free-form instructions into steps, dropping "STEP 1" style headings.
    var steps: [String] {
        let lines = instructions
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && !Self.isHeading($0) }
        guard lines.count == 1, let paragraph = lines.first else { return lines }
        return paragraph
            .components(separatedBy: ". ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { $0.hasSuffix(".") ? $0 : $0 + "." }
    }

    private static func isHeading(_ line: String) -> Bool {
        let lower = line.lowercased().trimmingCharacters(in: .punctuationCharacters)
        return lower.allSatisfy(\.isNumber) || (lower.hasPrefix("step") && lower.dropFirst(4).trimmingCharacters(in: .whitespaces).allSatisfy(\.isNumber))
    }
}
