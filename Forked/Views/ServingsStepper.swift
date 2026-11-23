// ServingsStepper.swift
// Plus and minus control that scales a recipe's ingredients by servings.

import SwiftUI

struct ServingsStepper: View {
    let baseServings: Int?
    @Binding var selection: Int

    private var label: String {
        baseServings == nil ? "\(selection)× batch" : Servings.label(selection)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.2").foregroundStyle(Theme.secondaryText)
            Text(label).font(.subheadline.weight(.medium)).monospacedDigit()
            if selection != (baseServings ?? 1) {
                Button("Reset") { selection = baseServings ?? 1 }
                    .font(.caption.weight(.semibold))
                    .buttonStyle(.borderless)
            }
            Spacer(minLength: 0)
            Stepper(label, value: $selection, in: Servings.range).labelsHidden()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
    }
}
