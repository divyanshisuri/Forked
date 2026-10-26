import SwiftUI

struct HomeHeaderBanner: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("Forked")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text("Fork it. Make it yours.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Theme.red)
    }
}
