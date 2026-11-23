// App entry point: opens the SwiftData store, upgrading older layouts, and seeds the sample data.
import SwiftUI
import SwiftData
import UserNotifications

@main
struct ForkedApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema(versionedSchema: ForkedSchemaV3.self)
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: AppEnvironment.isUITesting)
        do {
            container = try ModelContainer(
                for: schema,
                migrationPlan: ForkedMigrationPlan.self,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        if AppEnvironment.isUITesting {
            AppEnvironment.defaults.removePersistentDomain(forName: "ForkedUITests")
            AppEnvironment.defaults.set(true, forKey: OnboardingView.storageKey)
        }
        SeedData.seedIfNeeded(context: container.mainContext, defaults: AppEnvironment.defaults)
        SeedData.seedUsersIfNeeded(context: container.mainContext)
        UNUserNotificationCenter.current().delegate = NotificationPresenter.shared
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
