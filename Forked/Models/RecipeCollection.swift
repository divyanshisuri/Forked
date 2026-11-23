// RecipeCollection.swift
// A named group of saved recipes.

import Foundation
import SwiftData

@Model
final class RecipeCollection {
    var name: String
    var createdAt: Date

    @Relationship(deleteRule: .nullify, inverse: \Recipe.collections)
    var recipes: [Recipe]

    init(name: String, createdAt: Date = .now, recipes: [Recipe] = []) {
        self.name = name
        self.createdAt = createdAt
        self.recipes = recipes
    }
}
