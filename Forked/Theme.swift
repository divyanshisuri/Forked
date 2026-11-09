import SwiftUI
import UIKit

enum Theme {
    static let red = Color(light: Color(red: 0.65, green: 0.24, blue: 0.18),
                           dark: Color(red: 0.94, green: 0.52, blue: 0.40))
    static let background = Color(uiColor: .systemGroupedBackground)
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    static let surface = Color(uiColor: .tertiarySystemFill)
    static let text = Color.primary
    static let secondaryText = Color.secondary
    static let cardCorner: CGFloat = 20
}
extension Color {
    init(light: Color, dark: Color) {
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}
extension View {
    func redNavigationBar() -> some View { tint(Theme.red) }
}
struct RedButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Theme.red, in: RoundedRectangle(cornerRadius: 14))
            .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.4)
    }
}
extension ButtonStyle where Self == RedButtonStyle {
    static var red: RedButtonStyle { RedButtonStyle() }
}
