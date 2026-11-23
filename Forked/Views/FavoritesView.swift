// FavoritesView.swift
// Recipes marked as favorites, sortable.

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(filter: #Predicate<Recipe> { $0.isFavorite }, sort: \Recipe.createdAt, order: .reverse)
    private var recipes: [Recipe]
    @AppStorage(RecipeSort.storageKey) private var sort: RecipeSort = .newest

    var body: some View {
        List(sort.apply(to: recipes)) { recipe in
            NavigationLink(value: recipe) { RecipeRowView(recipe: recipe) }
                .listRowSeparator(.hidden)
                .recipeActions(recipe)
        }
        .overlay {
            if recipes.isEmpty {
                ContentUnavailableView("No Favorites", systemImage: "heart", description: Text("Tap the heart on a recipe to save it here."))
            }
        }
        .navigationTitle("Favorites")
        .redNavigationBar()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { RecipeSortMenu(selection: $sort) }
        }
    }
}
