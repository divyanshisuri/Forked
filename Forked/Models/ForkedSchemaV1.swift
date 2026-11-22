import SwiftData

/// The schema as of commit 96c3661. It points at the live model types, which is only correct
/// while they are unchanged. Before any non-additive change, copy the current models into this
/// enum as nested types so V1 stays frozen, then add a V2 and a migration stage.
nonisolated enum ForkedSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [Recipe.self, Rating.self, RecipeCollection.self, RecipeVersion.self]
    }
}
