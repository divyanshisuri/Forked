import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RecipePhotoView(photoData: recipe.photoData, imageURL: recipe.imageURL, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
                .overlay(alignment: .topTrailing) {
                    if recipe.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.subheadline)
                            .foregroundStyle(Theme.red)
                            .padding(10)
                            .background(Theme.cardBackground, in: Circle())
                            .padding(12)
                            .accessibilityLabel("Favorite")
                    }
                }
            VStack(alignment: .leading, spacing: 12) {
                Text(recipe.title)
                    .font(.title3.weight(.medium))
                    .fontDesign(.serif)
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
            .padding(.top, 16)
            .padding(.horizontal, 2)
            .padding(.bottom, 8)
        }
        .background(Theme.cardBackground)
        .contentShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
    }
}
