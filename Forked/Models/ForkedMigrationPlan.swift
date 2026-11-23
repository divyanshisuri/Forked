import SwiftData

nonisolated enum ForkedMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [ForkedSchemaV1.self] }

    static var stages: [MigrationStage] { [] }
}
