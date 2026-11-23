// WebRecipeCard.swift
// A card for one online recipe in the Discover grid.

import SwiftUI

struct WebRecipeCard: View {
    let recipe: WebRecipe

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RecipePhotoView(photoData: nil, imageURL: recipe.thumbnailURL, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
            Text(recipe.title)
                .font(.headline)
                .fontDesign(.serif)
                .foregroundStyle(Theme.text)
                .lineLimit(2, reservesSpace: true)
            Text(recipe.tags.joined(separator: " · "))
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
                .lineLimit(1)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
