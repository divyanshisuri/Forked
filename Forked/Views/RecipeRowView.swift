import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RecipePhotoView(photoData: recipe.photoData, imageURL: recipe.imageURL, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))

            HStack {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundStyle(Theme.red)

                if recipe.parent != nil {
                    Image(systemName: "arrow.triangle.branch")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(Theme.red)
                        .clipShape(Circle())
                }

                Spacer()

                if let average = recipe.averageRating {
                    HStack(spacing: 4) {
                        StarRatingView(rating: Int(average.rounded()), size: 12)
                        Text(String(format: "%.1f", average))
                            .font(.caption)
                            .foregroundStyle(Theme.text)
                    }
                }
            }

            if !recipe.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(recipe.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.caption2.weight(.bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Theme.red)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
    }
}
