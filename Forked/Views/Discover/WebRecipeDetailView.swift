// WebRecipeDetailView.swift
// Shows an online recipe and lets the user save it into their Forked cookbook.

import SwiftUI
import SwiftData

struct WebRecipeDetailView: View {
    let webRecipe: WebRecipe
    @Environment(\.modelContext) private var modelContext
    @Query private var recipes: [Recipe]
    @State private var savedRecipe: Recipe?
    @State private var saveError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                RecipePhotoView(photoData: nil, imageURL: webRecipe.thumbnailURL, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 8) {
                    Text(webRecipe.title)
                        .font(.largeTitle)
                        .fontDesign(.serif)
                        .foregroundStyle(Theme.text)
                    Label("From TheMealDB", systemImage: "globe")
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }
                if let savedRecipe {
                    NavigationLink {
                        RecipeDetailView(recipe: savedRecipe)
                    } label: {
                        Label("Saved. Open in My Cookbook", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.outline)
                } else {
                    Button(action: save) {
                        Label("Save to My Cookbook", systemImage: "square.and.arrow.down")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.red)
                    .disabled(webRecipe.ingredients.isEmpty || webRecipe.steps.isEmpty)
                }
                RedDivider()
                SectionHeader("Ingredients")
                Text(webRecipe.ingredients.map { "•  " + $0 }.joined(separator: "\n\n"))
                RedDivider()
                SectionHeader("Steps")
                ForEach(Array(webRecipe.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 14) {
                        Text("\(index + 1)")
                            .font(.subheadline.weight(.semibold).monospacedDigit())
                            .frame(width: 30, height: 30)
                            .background(Theme.surface, in: Circle())
                        Text(step).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .background(Theme.background)
        .navigationTitle("Online Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .redNavigationBar()
        .sensoryFeedback(.success, trigger: savedRecipe != nil)
        .alert("Could not save recipe", isPresented: Binding(get: { saveError != nil }, set: { if !$0 { saveError = nil } })) {
            Button("OK") { saveError = nil }
        } message: { Text(saveError ?? "") }
        .onAppear { savedRecipe = existingCopy() }
    }

    private func existingCopy() -> Recipe? {
        recipes.first { $0.title == webRecipe.title && $0.imageURL == webRecipe.thumbnailURL }
    }

    private func save() {
        let recipe = Recipe(title: webRecipe.title, ingredients: webRecipe.ingredients, steps: webRecipe.steps,
                            tags: webRecipe.tags, imageURL: webRecipe.thumbnailURL)
        recipe.isUserCreated = true
        modelContext.insert(recipe)
        do {
            try modelContext.save()
            savedRecipe = recipe
        } catch {
            modelContext.rollback()
            saveError = error.localizedDescription
        }
    }
}
