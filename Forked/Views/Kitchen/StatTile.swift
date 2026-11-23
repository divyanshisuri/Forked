// StatTile.swift
// A headline number with a label, used at the top of the Chef dashboard.

import SwiftUI

struct StatTile: View {
    let value: String
    let label: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: systemImage)
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
            Text(value)
                .font(.system(.title, design: .serif).weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(Theme.text)
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.cardCorner))
        .accessibilityElement(children: .combine)
    }
}
