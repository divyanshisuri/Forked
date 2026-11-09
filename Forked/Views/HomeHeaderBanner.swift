import SwiftUI

struct HomeHeaderBanner: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("A little inspiration.")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Theme.text)
            Text("Find something you love. Make it your own.")
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
