// RecipeShareText.swift
// Formats a recipe or a whole collection as plain text for the share sheet.

import Foundation

enum RecipeShareText {
    static func make(_ recipe: Recipe) -> String {
        var lines = [recipe.title]
        if let parent = recipe.parent {
            lines.append("Forked from \(parent.title)")
        }
        if let note = recipe.forkNote {
            lines.append("What changed: \(note)")
        }
        let facts = [
            recipe.servings.map(Servings.label),
            recipe.cookTimeMinutes.map(CookTime.label),
            recipe.averageRating.map { String(format: "%.1f stars", $0) }
        ].compactMap { $0 }
        if !facts.isEmpty { lines.append(facts.joined(separator: " · ")) }
        if !recipe.tags.isEmpty { lines.append(recipe.tags.joined(separator: ", ")) }
        lines.append("")
        lines.append("Ingredients")
        lines += recipe.ingredients.map { "• " + $0 }
        lines.append("")
        lines.append("Steps")
        lines += recipe.steps.enumerated().map { "\($0.offset + 1). \($0.element)" }
        lines.append("")
        lines.append("Shared from Forked")
        return lines.joined(separator: "\n")
    }

    static func make(collection name: String, recipes: [Recipe]) -> String {
        ([name, ""] + recipes.map { make($0) }).joined(separator: "\n\n")
    }
}
