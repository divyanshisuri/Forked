import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Bindable var recipe: Recipe
    @Environment(\.modelContext) private var modelContext
    @State private var showingForkForm = false
    @State private var ownRatingValue: Int

    init(recipe: Recipe) {
        self.recipe = recipe
        _ownRatingValue = State(initialValue: recipe.ownRating?.stars ?? 0)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                RecipePhotoView(photoData: recipe.photoData, imageURL: recipe.imageURL, height: 320)

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(recipe.title)
                                .font(.largeTitle.weight(.bold))
                                .fontDesign(.rounded)
                                .foregroundStyle(Theme.text)
                            if recipe.parent != nil {
                                Image(systemName: "arrow.triangle.branch")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(6)
                                    .background(Theme.red)
                                    .clipShape(Circle())
                            }
                        }

                        if let parent = recipe.parent {
                            NavigationLink(value: parent) {
                                Label("Forked from \(parent.title)", systemImage: "arrow.turn.up.left")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.red)
                            }
                        }

                        if let average = recipe.averageRating {
                            HStack(spacing: 6) {
                                StarRatingView(rating: Int(average.rounded()))
                                Text(String(format: "%.1f (%d rating%@)", average, recipe.ratings.count, recipe.ratings.count == 1 ? "" : "s"))
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.secondaryText)
                            }
                        }

                        if !recipe.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(recipe.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption.weight(.bold))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Theme.red)
                                            .foregroundStyle(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    RedDivider()

                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader("Your Rating")
                        StarRatingPicker(rating: $ownRatingValue)
                            .onChange(of: ownRatingValue) { _, newValue in
                                updateOwnRating(newValue)
                            }
                    }

                    Button {
                        showingForkForm = true
                    } label: {
                        Label("Fork This Recipe", systemImage: "arrow.triangle.branch")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.red)

                    RedDivider()

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Ingredients")
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("•  \(ingredient)")
                                .foregroundStyle(Theme.text)
                        }
                    }

                    RedDivider()

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Steps")
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1).  \(step)")
                                .foregroundStyle(Theme.text)
                        }
                    }

                    if !recipe.variations.isEmpty {
                        RedDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Variations")
                            ForEach(recipe.variations) { variation in
                                NavigationLink(value: variation) {
                                    RecipeRowView(recipe: variation)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Theme.background)
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .redNavigationBar()
        .fullScreenCover(isPresented: $showingForkForm) {
            RecipeFormView(parent: recipe)
        }
    }

    private func updateOwnRating(_ stars: Int) {
        if let existing = recipe.ownRating {
            existing.stars = stars
        } else {
            let rating = Rating(stars: stars, isOwn: true, recipe: recipe)
            modelContext.insert(rating)
        }
    }
}
