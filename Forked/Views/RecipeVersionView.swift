import SwiftUI

struct RecipeVersionView: View {
    let version: RecipeVersion
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Saved before edit").font(.caption)
                Text(version.savedAt, format: .dateTime)
                RecipePhotoView(photoData: version.content.photoData, imageURL: version.content.imageURL, height: 240)
                Text(version.content.title).font(.title.bold())
                if let minutes = version.content.cookTimeMinutes {
                    Label(CookTime.label(minutes), systemImage: "clock")
                }
                Text(version.content.tags.joined(separator: ", ")).foregroundStyle(Theme.secondaryText)
                SectionHeader("Ingredients")
                Text(version.content.ingredients.map { "• " + $0 }.joined(separator: "\n"))
                SectionHeader("Steps")
                Text(version.content.steps.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n\n"))
            }
            .padding()
        }
        .navigationTitle("Previous Version")
        .redNavigationBar()
    }
}
