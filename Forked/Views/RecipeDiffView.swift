import SwiftUI

struct RecipeDiffView: View {
    let diff: RecipeDiff

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Changes from Original")
            if diff.changes.isEmpty { Text("No changes") }
            ForEach(diff.changes) { change in
                VStack(alignment: .leading, spacing: 4) {
                    Text(change.field).font(.headline)
                    Text("Original: " + (change.before.isEmpty ? "None" : change.before))
                        .foregroundStyle(Theme.secondaryText)
                    Text("Variation: " + (change.after.isEmpty ? "None" : change.after))
                }
            }
        }
    }
}
