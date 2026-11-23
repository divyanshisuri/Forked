// App entry point: opens the SwiftData store, upgrading older layouts, and seeds the sample data.
import SwiftUI
import SwiftData

@main
struct ForkedApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema(versionedSchema: ForkedSchemaV2.self)
        let configuration = ModelConfiguration(schema: schema)
        do {
            container = try ModelContainer(
                for: schema,
                migrationPlan: ForkedMigrationPlan.self,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        SeedData.seedIfNeeded(context: container.mainContext)
        SeedData.seedUsersIfNeeded(context: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
