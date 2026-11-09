import SwiftUI
import UIKit

enum Theme {
    // A monochrome accent keeps the interface quiet and lets food photography lead.
    static let red = Color(uiColor: .label)
    static let background = Color(uiColor: .systemBackground)
    static let cardBackground = Color(uiColor: .systemBackground)
    static let surface = Color(light: Color(white: 0.965), dark: Color(white: 0.13))
    static let separator = Color.primary.opacity(0.09)
    static let onAccent = Color(uiColor: .systemBackground)
    static let text = Color.primary
    static let secondaryText = Color.secondary
    static let cardCorner: CGFloat = 14
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
            .foregroundStyle(Theme.onAccent)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Theme.red, in: RoundedRectangle(cornerRadius: 12))
            .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.4)
    }
}
extension ButtonStyle where Self == RedButtonStyle {
    static var red: RedButtonStyle { RedButtonStyle() }
}
