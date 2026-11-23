// ShoppingItem.swift
// One line on the shopping list, labelled with the recipe it came from.

import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var text: String
    var isChecked: Bool = false
    var recipeTitle: String?
    var createdAt: Date

    init(text: String, recipeTitle: String? = nil, createdAt: Date = .now) {
        self.text = text
        self.recipeTitle = recipeTitle
        self.createdAt = createdAt
    }
}
