import SwiftUI

struct RecipeHistoryView: View {
    let recipe: Recipe
    private var versions: [RecipeVersion] { recipe.versions.sorted { $0.savedAt > $1.savedAt } }

    var body: some View {
        List(versions) { version in
            NavigationLink {
                RecipeVersionView(version: version)
            } label: {
                VStack(alignment: .leading) {
                    Text(version.content.title).font(.headline)
                    Text(version.savedAt, format: .dateTime.year().month().day().hour().minute().second())
                        .font(.caption)
                }
            }
        }
        .overlay {
            if versions.isEmpty {
                ContentUnavailableView("No Previous Versions", systemImage: "clock", description: Text("Previous versions appear here after you edit this recipe."))
            }
        }
        .navigationTitle("Version History")
        .redNavigationBar()
    }
}
