import SwiftUI

struct SectionHeader: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title3.weight(.bold))
            .fontDesign(.rounded)
            .foregroundStyle(Theme.red)
    }
}
