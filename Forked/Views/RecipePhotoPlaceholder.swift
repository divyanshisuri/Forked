import SwiftUI

struct RecipePhotoPlaceholder: View {
    var showsProgress: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.red, Theme.red.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            if showsProgress {
                ProgressView()
                    .tint(.white)
            } else {
                Image(systemName: "fork.knife")
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
    }
}
