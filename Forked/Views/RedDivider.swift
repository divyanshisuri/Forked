import SwiftUI

struct RedDivider: View {
    var body: some View {
        Rectangle()
            .fill(Theme.red.opacity(0.3))
            .frame(height: 1)
    }
}
