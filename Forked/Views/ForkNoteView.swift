// ForkNoteView.swift
// Shows a fork's "what changed" note.

import SwiftUI

struct ForkNoteView: View {
    let note: String

    var body: some View {
        Label {
            Text(note).italic()
        } icon: {
            Image(systemName: "quote.opening")
        }
        .font(.subheadline)
        .foregroundStyle(Theme.secondaryText)
        .accessibilityLabel("What changed: \(note)")
    }
}
