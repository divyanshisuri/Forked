// LoadingCardsView.swift
// Placeholder cards shown while Discover loads, so users can see something is happening.

import SwiftUI

struct LoadingCardsView: View {
    let columns: [GridItem]
    @State private var pulse = false

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(0..<6, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: Theme.cardCorner).fill(Theme.surface).frame(height: 180)
                    RoundedRectangle(cornerRadius: 4).fill(Theme.surface).frame(height: 16)
                    RoundedRectangle(cornerRadius: 4).fill(Theme.surface).frame(width: 100, height: 12)
                }
            }
        }
        .opacity(pulse ? 0.5 : 1)
        .animation(.easeInOut(duration: 0.8).repeatForever(), value: pulse)
        .onAppear { pulse = true }
        .accessibilityElement()
        .accessibilityLabel("Loading recipes")
        .overlay { ProgressView().controlSize(.large) }
    }
}
