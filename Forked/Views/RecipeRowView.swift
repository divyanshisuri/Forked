import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RecipePhotoView(photoData: recipe.photoData, imageURL: recipe.imageURL, height: 200)
                .overlay(alignment: .topTrailing) {
                    if recipe.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.subheadline)
                            .foregroundStyle(Theme.red)
                            .padding(10)
                            .background(.regularMaterial, in: Circle())
                            .padding(12)
                            .accessibilityLabel("Favorite")
                    }
                }
            VStack(alignment: .leading, spacing: 12) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundStyle(Theme.text)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: true)
                HStack(spacing: 12) {
                    if let minutes = recipe.cookTimeMinutes {
                        Label(CookTime.label(minutes), systemImage: "clock")
                    }
                    if let average = recipe.averageRating {
                        Label(String(format: "%.1f", average), systemImage: "star.fill")
                    }
                    Spacer(minLength: 0)
                    if recipe.parent != nil {
                        Image(systemName: "arrow.triangle.branch").accessibilityLabel("Variation")
                    }
                }
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
                if !recipe.tags.isEmpty {
                    Text(recipe.tags.prefix(3).joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                        .lineLimit(1)
                }
            }
            .padding(16)
        }
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
        .overlay {
            RoundedRectangle(cornerRadius: Theme.cardCorner)
                .strokeBorder(.primary.opacity(0.05), lineWidth: 1)
        }
        .contentShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
    }
}
