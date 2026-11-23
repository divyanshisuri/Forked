// RecipeSortMenu.swift
// Menu for choosing how recipe lists are sorted.

import SwiftUI

struct RecipeSortMenu: View {
    @Binding var selection: RecipeSort

    var body: some View {
        Menu {
            Picker("Sort by", selection: $selection) {
                ForEach(RecipeSort.allCases) { sort in
                    Label(sort.rawValue, systemImage: sort.systemImage).tag(sort)
                }
            }
        } label: {
            Label(selection.rawValue, systemImage: "arrow.up.arrow.down")
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
        }
        .accessibilityLabel("Sort by \(selection.rawValue)")
    }
}
