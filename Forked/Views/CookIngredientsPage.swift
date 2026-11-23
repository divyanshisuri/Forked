// CookIngredientsPage.swift
// First page of cook mode: a checklist for gathering ingredients.

import SwiftUI

struct CookIngredientsPage: View {
    let ingredients: [String]
    @Binding var gathered: Set<Int>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("GATHER YOUR INGREDIENTS")
                    .font(.caption.weight(.semibold))
                    .tracking(1.8)
                    .foregroundStyle(Theme.secondaryText)
                ForEach(Array(ingredients.enumerated()), id: \.offset) { index, ingredient in
                    let isGathered = gathered.contains(index)
                    Button {
                        if isGathered { gathered.remove(index) } else { gathered.insert(index) }
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 14) {
                            Image(systemName: isGathered ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(isGathered ? Theme.red : Theme.secondaryText)
                            Text(ingredient)
                                .font(.title3)
                                .strikethrough(isGathered)
                                .foregroundStyle(isGathered ? Theme.secondaryText : Theme.text)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isGathered ? .isSelected : [])
                }
            }
            .padding(24)
            .frame(maxWidth: 700, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
    }
}
