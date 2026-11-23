// ShoppingList.swift
// Adds a recipe's ingredients to the shopping list and formats the list for sharing.

import Foundation
import SwiftData

enum ShoppingList {
    /// Adds each ingredient, scaled by `factor`, unless it's already on the list unchecked. Returns how many were added.
    @discardableResult
    static func add(_ recipe: Recipe, factor: Double = 1, context: ModelContext) throws -> Int {
        let existing = try context.fetch(FetchDescriptor<ShoppingItem>(predicate: #Predicate { !$0.isChecked }))
        // Functional: map builds the set of items already on the list.
        var known = Set(existing.map { $0.text.lowercased() })
        var added = 0
        for ingredient in recipe.ingredients {
            let text = IngredientScaler.scale(ingredient, by: factor)
            guard known.insert(text.lowercased()).inserted else { continue }
            let item = ShoppingItem(text: text, recipeTitle: recipe.title,
                                    createdAt: .now.addingTimeInterval(Double(added) / 1000))
            context.insert(item)
            added += 1
        }
        try context.save()
        return added
    }

    static func text(for items: [ShoppingItem]) -> String {
        (["Shopping List"] + items.map { "☐ " + $0.text }).joined(separator: "\n")
    }
}
