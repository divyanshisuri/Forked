import SwiftUI

struct HomeHeaderBanner: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Good food. Made your own.")
                .font(.largeTitle.weight(.regular))
                .fontDesign(.serif)
                .foregroundStyle(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
            Text("Your collection of recipes, ideas, and little improvements.")
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}
