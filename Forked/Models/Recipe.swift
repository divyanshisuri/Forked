import Foundation
import SwiftData

@Model
final class Recipe {
    var title: String
    var ingredients: [String]
    var steps: [String]
    var tags: [String]
    @Attribute(.externalStorage) var photoData: Data?
    var imageURL: String?
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
