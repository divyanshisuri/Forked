import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Bindable var recipe: Recipe
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditForm = false
    @State private var favoriteError: String?
    @State private var showingForkForm = false
    @State private var ownRatingValue: Int

    init(recipe: Recipe) {
        self.recipe = recipe
        _ownRatingValue = State(initialValue: recipe.ownRating?.stars ?? 0)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                RecipePhotoView(photoData: recipe.photoData, imageURL: recipe.imageURL, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding([.horizontal, .top], 20)

                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(recipe.title)
                                .font(.largeTitle.weight(.regular))
                                .fontDesign(.serif)
                                .foregroundStyle(Theme.text)
                            if recipe.parent != nil {
                                Image(systemName: "arrow.triangle.branch")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(Theme.onAccent)
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
                                            .background(Theme.surface)
                                            .foregroundStyle(Theme.secondaryText)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    if let minutes = recipe.cookTimeMinutes {
                        Label(CookTime.label(minutes), systemImage: "clock")
                    }
                    if let parent = recipe.parent {
                        RecipeDiffView(diff: RecipeDiff(original: RecipeContent(recipe: parent), variation: RecipeContent(recipe: recipe)))
                    }


                    RedDivider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your rating").font(.subheadline).foregroundStyle(.secondary)
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
                        Text(recipe.ingredients.map { "•  " + $0 }.joined(separator: "\n\n"))
                            .foregroundStyle(Theme.text)
                    }

                    RedDivider()

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Steps")
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.subheadline.weight(.semibold).monospacedDigit())
                                    .foregroundStyle(Theme.red)
                                    .frame(width: 30, height: 30)
                                    .background(Theme.red.opacity(0.1), in: Circle())
                                Text(step).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 6)
                        }
                    }

                    if !recipe.variations.isEmpty {
                        RedDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader("Variations")
                            ForEach(recipe.variations) { variation in
                                NavigationLink(value: variation) {
                                    VStack(alignment: .leading) {
                                        RecipeRowView(recipe: variation)
                                        Text(RecipeDiff(original: RecipeContent(recipe: recipe), variation: RecipeContent(recipe: variation)).summary)
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(24)
            }
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .background(Theme.background)
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .redNavigationBar()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    recipe.isFavorite.toggle()
                    do { try modelContext.save() } catch {
                        modelContext.rollback()
                        favoriteError = error.localizedDescription
                    }
                } label: {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                }
                .accessibilityLabel(recipe.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                NavigationLink {
                    RecipeHistoryView(recipe: recipe)
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
                .accessibilityLabel("Version history")
                if recipe.isUserCreated {
                    Button("Edit") { showingEditForm = true }
                }
            }
        }
        .alert("Could not save favorite", isPresented: Binding(get: { favoriteError != nil }, set: { if !$0 { favoriteError = nil } })) {
            Button("OK") { favoriteError = nil }
        } message: { Text(favoriteError ?? "") }
        .sheet(isPresented: $showingEditForm) {
            RecipeFormView(editingRecipe: recipe)
        }
        .sheet(isPresented: $showingForkForm) {
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
