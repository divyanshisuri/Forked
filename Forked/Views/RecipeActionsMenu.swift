// RecipeActionsMenu.swift
// Long-press menu shared by every recipe card: cook, add to list, share and favorite.

import SwiftUI
import SwiftData

struct RecipeActionsMenu: ViewModifier {
    let recipe: Recipe
    @Environment(\.modelContext) private var modelContext
    @State private var cooking = false
    @State private var addedCount = 0
    @State private var errorMessage: String?

    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button { cooking = true } label: { Label("Start Cooking", systemImage: "frying.pan") }
                Button(action: addToList) { Label("Add to Shopping List", systemImage: "cart.badge.plus") }
                ShareLink(item: RecipeShareText.make(recipe), subject: Text(recipe.title)) {
                    Label("Share Recipe", systemImage: "square.and.arrow.up")
                }
                Button(action: toggleFavorite) {
                    Label(recipe.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                          systemImage: recipe.isFavorite ? "heart.slash" : "heart")
                }
            }
            .fullScreenCover(isPresented: $cooking) { CookModeView(recipe: recipe) }
            .sensoryFeedback(.success, trigger: addedCount)
            .alert("Something went wrong", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
                Button("OK") { errorMessage = nil }
            } message: { Text(errorMessage ?? "") }
    }

    private func addToList() {
        do { addedCount += try ShoppingList.add(recipe, context: modelContext) + 1 } catch {
            modelContext.rollback()
            errorMessage = error.localizedDescription
        }
    }

    private func toggleFavorite() {
        recipe.isFavorite.toggle()
        do { try modelContext.save() } catch {
            modelContext.rollback()
            errorMessage = error.localizedDescription
        }
    }
}

extension View {
    func recipeActions(_ recipe: Recipe) -> some View { modifier(RecipeActionsMenu(recipe: recipe)) }
}
