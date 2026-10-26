import SwiftUI
import UIKit

enum Theme {
    static let red = Color(red: 0.839, green: 0.157, blue: 0.157)

    static let background = Color(light: .white, dark: Color(white: 0.067))
    static let surface = Color(light: Color(white: 0.96), dark: Color(white: 0.12))
    static let text = Color(light: Color(white: 0.067), dark: .white)
    static let secondaryText = text.opacity(0.6)

    static let cardCorner: CGFloat = 16
}

extension Color {
    init(light: Color, dark: Color) {
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

extension View {
    func redNavigationBar() -> some View {
        self
            .toolbarBackground(Theme.red, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct RedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.bold))
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Theme.red)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == RedButtonStyle {
    static var red: RedButtonStyle { RedButtonStyle() }
}
