// OfflineBanner.swift
// Tells the user Discover is showing saved results because the network is unavailable.

import SwiftUI

struct OfflineBanner: View {
    let savedAt: Date
    let onRetry: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi.slash")
            VStack(alignment: .leading, spacing: 2) {
                Text("You're offline").font(.subheadline.weight(.semibold))
                Text("Showing recipes saved \(savedAt.formatted(.relative(presentation: .named))).")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }
            Spacer(minLength: 0)
            Button("Retry", action: onRetry)
                .font(.subheadline.weight(.semibold))
                .buttonStyle(.borderless)
        }
        .padding(14)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}
