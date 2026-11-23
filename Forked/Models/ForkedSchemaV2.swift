// The current data model: the live recipe models plus User, added for accounts in KAN-9.
import SwiftData

// V2 lists the live model types, so it is only accurate while they are unchanged. Before the next
// non-additive change, freeze these as nested copies the same way as ForkedSchemaV1, then add a V3.
nonisolated enum ForkedSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [Recipe.self, Rating.self, RecipeCollection.self, RecipeVersion.self, User.self]
    }
}
