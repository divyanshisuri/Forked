// Recipe.swift
// The core recipe model. A recipe can be forked into variations that keep a link to their parent.

import Foundation
import SwiftData

// PARADIGM: Object-oriented. A model class with relationships to its author, parent, variations and ratings.
@Model
final class Recipe {
    var title: String
    var ingredients: [String]
    var steps: [String]
    var tags: [String]
    @Attribute(.externalStorage) var photoData: Data?
    var imageURL: String?
    var cookTimeMinutes: Int?
    var servings: Int?
    var forkNote: String?
    var isUserCreated: Bool = false
    var ownershipAssigned: Bool = false
    var isFavorite: Bool = false

    @Relationship(deleteRule: .cascade, inverse: \RecipeVersion.recipe)
    var versions: [RecipeVersion] = []

    var createdAt: Date

    var parent: Recipe?

    @Relationship(deleteRule: .nullify, inverse: \Recipe.parent)
    var variations: [Recipe]

    @Relationship(deleteRule: .cascade, inverse: \Rating.recipe)
    var ratings: [Rating]

    var collections: [RecipeCollection]

    init(
        title: String = "",
        ingredients: [String] = [],
        steps: [String] = [],
        tags: [String] = [],
        photoData: Data? = nil,
        imageURL: String? = nil,
        createdAt: Date = .now,
        parent: Recipe? = nil
    ) {
        self.ownershipAssigned = true
        self.title = title
        self.ingredients = ingredients
        self.steps = steps
        self.tags = tags
        self.photoData = photoData
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.parent = parent
        self.variations = []
        self.ratings = []
        self.collections = []
    }
}

extension Recipe {
    // PARADIGM: Functional. reduce folds every rating into a single total.
    var averageRating: Double? {
        guard !ratings.isEmpty else { return nil }
        let total = ratings.reduce(0) { $0 + $1.stars }
        return Double(total) / Double(ratings.count)
    }

    var ownRating: Rating? {
        ratings.first { $0.isOwn }
    }

    func matches(name query: String) -> Bool {
        title.localizedCaseInsensitiveContains(query)
    }

    func matches(ingredient query: String) -> Bool {
        ingredients.contains { $0.localizedCaseInsensitiveContains(query) }
    }
}
