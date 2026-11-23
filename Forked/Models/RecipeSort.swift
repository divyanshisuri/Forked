// RecipeSort.swift
// The ways a recipe list can be sorted: newest, top rated, quickest, most forked, A to Z.

import Foundation

enum RecipeSort: String, CaseIterable, Identifiable {
    case newest = "Newest"
    case topRated = "Top Rated"
    case quickest = "Quickest"
    case mostForked = "Most Forked"
    case alphabetical = "A to Z"

    static let storageKey = "recipeSort"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .newest: "calendar"
        case .topRated: "star"
        case .quickest: "clock"
        case .mostForked: "arrow.triangle.branch"
        case .alphabetical: "textformat"
        }
    }

    func apply(to recipes: [Recipe]) -> [Recipe] {
        switch self {
        case .newest:
            recipes.sorted { $0.createdAt > $1.createdAt }
        case .topRated:
            recipes.sorted { ($0.averageRating ?? 0, $0.ratings.count) > ($1.averageRating ?? 0, $1.ratings.count) }
        case .quickest:
            recipes.sorted { ($0.cookTimeMinutes ?? .max) < ($1.cookTimeMinutes ?? .max) }
        case .mostForked:
            recipes.sorted { $0.variations.count > $1.variations.count }
        case .alphabetical:
            recipes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }
}
