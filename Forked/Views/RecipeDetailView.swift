// A recipe's full page: photo, rating, fork and edit actions, ingredients, steps,
// changes from the original and its variations.
import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Bindable var recipe: Recipe
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditForm = false
    @State private var favoriteError: String?
    @State private var showingForkForm = false
    @State private var ownRatingValue: Int
    @State private var cooking = false
    @State private var servingsSelection: Int
    @State private var addedToList = false
    @State private var listError: String?

    init(recipe: Recipe) {
        self.recipe = recipe
        _ownRatingValue = State(initialValue: recipe.ownRating?.stars ?? 0)
        _servingsSelection = State(initialValue: recipe.servings ?? 1)
    }

    private var scaleFactor: Double {
        Double(servingsSelection) / Double(recipe.servings ?? 1)
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

                        if let note = recipe.forkNote {
                            ForkNoteView(note: note)
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

                    if recipe.cookTimeMinutes != nil || recipe.servings != nil {
                        HStack(spacing: 20) {
                            if let minutes = recipe.cookTimeMinutes {
                                Label(CookTime.label(minutes), systemImage: "clock")
                            }
                            if let servings = recipe.servings {
                                Label(Servings.label(servings), systemImage: "person.2")
                            }
                        }
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

                    HStack(spacing: 12) {
                        Button {
                            cooking = true
                        } label: {
                            Label("Start Cooking", systemImage: "frying.pan")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.red)
                        Button {
                            showingForkForm = true
                        } label: {
                            Label("Fork", systemImage: "arrow.triangle.branch")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.outline)
                    }

                    RedDivider()

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            SectionHeader("Ingredients")
                            Spacer()
                            Button(action: addToShoppingList) {
                                Label(addedToList ? "Added" : "Add to List",
                                      systemImage: addedToList ? "checkmark" : "cart.badge.plus")
                                    .font(.subheadline.weight(.medium))
                            }
                            .buttonStyle(.borderless)
                            .disabled(addedToList)
                            .sensoryFeedback(.success, trigger: addedToList) { _, added in added }
                        }
                        ServingsStepper(baseServings: recipe.servings, selection: $servingsSelection)
                        Text(recipe.ingredients.map { "•  " + IngredientScaler.scale($0, by: scaleFactor) }.joined(separator: "\n\n"))
                            .foregroundStyle(Theme.text)
                            .contentTransition(.numericText())
                            .animation(.default, value: servingsSelection)
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
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(step)
                                    if let minutes = StepDuration.minutes(in: step) {
                                        Label(CookTime.label(minutes) + " timer in cook mode", systemImage: "timer")
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                                    VStack(alignment: .leading, spacing: 6) {
                                        RecipeRowView(recipe: variation)
                                        if let note = variation.forkNote {
                                            ForkNoteView(note: note)
                                        }
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
                ShareLink(item: RecipeShareText.make(recipe), subject: Text(recipe.title)) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share recipe")
                // Editable recipes keep the button even with no versions, so its empty state can
                // explain that saving an edit creates one. Sample recipes would only ever be empty.
                if !recipe.versions.isEmpty || recipe.isUserCreated {
                    NavigationLink {
                        RecipeHistoryView(recipe: recipe)
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .accessibilityLabel("Version history")
                }
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
        .fullScreenCover(isPresented: $cooking) {
            CookModeView(recipe: recipe, factor: scaleFactor)
        }
        .alert("Could not add to list", isPresented: Binding(get: { listError != nil }, set: { if !$0 { listError = nil } })) {
            Button("OK") { listError = nil }
        } message: { Text(listError ?? "") }
        .onChange(of: recipe.servings) { _, newValue in servingsSelection = newValue ?? 1 }
        .onChange(of: servingsSelection) { addedToList = false }
    }

    private func addToShoppingList() {
        do {
            try ShoppingList.add(recipe, factor: scaleFactor, context: modelContext)
            addedToList = true
        } catch {
            modelContext.rollback()
            listError = error.localizedDescription
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
