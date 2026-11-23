// Lists every saved layout of the app's data and how SwiftData upgrades a store from one to the next.
import SwiftData

nonisolated enum ForkedMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [ForkedSchemaV1.self, ForkedSchemaV2.self] }

    /// V1 to V2 only adds the User table, so SwiftData can upgrade it automatically.
    static var stages: [MigrationStage] {
        [.lightweight(fromVersion: ForkedSchemaV1.self, toVersion: ForkedSchemaV2.self)]
    }
}
