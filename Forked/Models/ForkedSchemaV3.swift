// The current data model: adds recipe servings and fork notes, and the shopping list.
import SwiftData

// V3 lists the live model types, so it is only accurate while they are unchanged. Before the next
// change, freeze these as nested copies the same way as ForkedSchemaV2, then add a V4.
nonisolated enum ForkedSchemaV3: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(3, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [Recipe.self, Rating.self, RecipeCollection.self, RecipeVersion.self, User.self, ShoppingItem.self]
    }
}
