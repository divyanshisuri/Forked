import SwiftUI
import SwiftData

@main
struct ForkedApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([Recipe.self, Rating.self, RecipeCollection.self])
        let configuration = ModelConfiguration(schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        SeedData.seedIfNeeded(context: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
