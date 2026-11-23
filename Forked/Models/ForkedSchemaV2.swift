// The data model with accounts (KAN-9), kept as frozen copies so SwiftData can recognise
// stores saved in this layout and upgrade them to V3.
import Foundation
import SwiftData

// Never edit these copies. Every relationship points at the nested V2 types, never at the live models.
nonisolated enum ForkedSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            ForkedSchemaV2.Recipe.self,
            ForkedSchemaV2.Rating.self,
            ForkedSchemaV2.RecipeCollection.self,
            ForkedSchemaV2.RecipeVersion.self,
            ForkedSchemaV2.User.self
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

        @Relationship(deleteRule: .cascade, inverse: \ForkedSchemaV2.RecipeVersion.recipe)
        var versions: [ForkedSchemaV2.RecipeVersion] = []

        var createdAt: Date

        var parent: ForkedSchemaV2.Recipe?

        @Relationship(deleteRule: .nullify, inverse: \ForkedSchemaV2.Recipe.parent)
        var variations: [ForkedSchemaV2.Recipe]

        @Relationship(deleteRule: .cascade, inverse: \ForkedSchemaV2.Rating.recipe)
        var ratings: [ForkedSchemaV2.Rating]

        var collections: [ForkedSchemaV2.RecipeCollection]

        init(
            title: String = "",
            ingredients: [String] = [],
            steps: [String] = [],
            tags: [String] = [],
            photoData: Data? = nil,
            imageURL: String? = nil,
            createdAt: Date = .now,
            parent: ForkedSchemaV2.Recipe? = nil
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
        var recipe: ForkedSchemaV2.Recipe?

        init(stars: Int, isOwn: Bool = false, createdAt: Date = .now, recipe: ForkedSchemaV2.Recipe? = nil) {
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

        @Relationship(deleteRule: .nullify, inverse: \ForkedSchemaV2.Recipe.collections)
        var recipes: [ForkedSchemaV2.Recipe]

        init(name: String, createdAt: Date = .now, recipes: [ForkedSchemaV2.Recipe] = []) {
            self.name = name
            self.createdAt = createdAt
            self.recipes = recipes
        }
    }

    @Model
    final class RecipeVersion {
        var savedAt: Date = Date.now
        var content: ForkedSchemaV2.RecipeContent
        var recipe: ForkedSchemaV2.Recipe?

        init(content: ForkedSchemaV2.RecipeContent, recipe: ForkedSchemaV2.Recipe) {
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

    @Model
    final class User {
        var accountID: UUID = UUID()
        var username: String = ""
        var usernameKey: String = ""
        var roleRawValue: String = "consumer"
        var passwordHash: Data = Data()
        var passwordSalt: Data = Data()
        var passwordIterations: Int = 0
        var createdAt: Date = Date.now

        init(username: String = "") {
            self.accountID = UUID()
            self.username = username
        }
    }
}
