// Lists every saved layout of the app's data and how SwiftData upgrades a store from one to the next.
import SwiftData

nonisolated enum ForkedMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [ForkedSchemaV1.self, ForkedSchemaV2.self, ForkedSchemaV3.self] }

    /// Each step only adds tables or optional columns, so SwiftData can upgrade automatically.
    static var stages: [MigrationStage] {
        [
            .lightweight(fromVersion: ForkedSchemaV1.self, toVersion: ForkedSchemaV2.self),
            .lightweight(fromVersion: ForkedSchemaV2.self, toVersion: ForkedSchemaV3.self)
        ]
    }
}
