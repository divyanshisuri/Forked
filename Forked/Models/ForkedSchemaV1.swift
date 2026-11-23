// The app's data model before accounts existed (commits 96c3661 to c7067e9), kept as frozen copies
// so SwiftData can recognise stores saved in this layout and upgrade them to V2.
import Foundation
import SwiftData

// Never edit these copies. SwiftData identifies an existing store by matching its tables against
// each version in the migration plan, so any change here would stop old installs from opening.
// Every relationship points at the nested V1 types, never at the live models.
nonisolated enum ForkedSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            ForkedSchemaV1.Recipe.self,
            ForkedSchemaV1.Rating.self,
            ForkedSchemaV1.RecipeCollection.self,
            ForkedSchemaV1.RecipeVersion.self
        ]
    }

    @Model
    final class Recipe {
        var title: String
        var ingredients: [String]
        var steps: [String]
        var tags: [String]
        @Attribute(.externalStorage) var photoData: Data?
        var imageURL: String?
        var cookTimeMinutes: Int?
        var isUserCreated: Bool = false
        var ownershipAssigned: Bool = false
        var isFavorite: Bool = false

        @Relationship(deleteRule: .cascade, inverse: \ForkedSchemaV1.RecipeVersion.recipe)
        var versions: [ForkedSchemaV1.RecipeVersion] = []

        var createdAt: Date

        var parent: ForkedSchemaV1.Recipe?

        @Relationship(deleteRule: .nullify, inverse: \ForkedSchemaV1.Recipe.parent)
        var variations: [ForkedSchemaV1.Recipe]

        @Relationship(deleteRule: .cascade, inverse: \ForkedSchemaV1.Rating.recipe)
        var ratings: [ForkedSchemaV1.Rating]

        var collections: [ForkedSchemaV1.RecipeCollection]

        init(
            title: String = "",
            ingredients: [String] = [],
            steps: [String] = [],
            tags: [String] = [],
            photoData: Data? = nil,
            imageURL: String? = nil,
            createdAt: Date = .now,
            parent: ForkedSchemaV1.Recipe? = nil
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

    @Model
    final class Rating {
        var stars: Int
        var isOwn: Bool
        var createdAt: Date
        var recipe: ForkedSchemaV1.Recipe?

        init(stars: Int, isOwn: Bool = false, createdAt: Date = .now, recipe: ForkedSchemaV1.Recipe? = nil) {
            self.stars = min(max(stars, 1), 5)
            self.isOwn = isOwn
            self.createdAt = createdAt
            self.recipe = recipe
        }
    }

    @Model
    final class RecipeCollection {
        var name: String
        var createdAt: Date

        @Relationship(deleteRule: .nullify, inverse: \ForkedSchemaV1.Recipe.collections)
        var recipes: [ForkedSchemaV1.Recipe]

        init(name: String, createdAt: Date = .now, recipes: [ForkedSchemaV1.Recipe] = []) {
            self.name = name
            self.createdAt = createdAt
            self.recipes = recipes
        }
    }

    @Model
    final class RecipeVersion {
        var savedAt: Date = Date.now
        var content: ForkedSchemaV1.RecipeContent
        var recipe: ForkedSchemaV1.Recipe?

        init(content: ForkedSchemaV1.RecipeContent, recipe: ForkedSchemaV1.Recipe) {
            self.content = content
            self.recipe = recipe
        }
    }

    /// Frozen copy of the snapshot that `RecipeVersion` stores as a composite attribute.
    nonisolated struct RecipeContent: Codable, Equatable, Sendable {
        var title: String
        var ingredients: [String]
        var steps: [String]
        var tags: [String]
        var photoData: Data?
        var imageURL: String?
        var cookTimeMinutes: Int?
    }
}
