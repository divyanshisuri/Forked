// CollectionDetailView.swift
// The recipes in one collection, sortable and shareable.

import SwiftUI
import SwiftData

struct CollectionDetailView: View {
    @Bindable var collection: RecipeCollection
    @State private var showingAddRecipes = false
    @AppStorage(RecipeSort.storageKey) private var sort: RecipeSort = .newest

    private var sortedRecipes: [Recipe] { sort.apply(to: collection.recipes) }

    var body: some View {
        Group {
            if collection.recipes.isEmpty {
                ContentUnavailableView(
                    "No Recipes Yet",
                    systemImage: "book",
                    description: Text("Add recipes to this collection.")
                )
            } else {
                List {
                    ForEach(sortedRecipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeRowView(recipe: recipe)
                        }
                        .recipeActions(recipe)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Theme.background)
                    }
                    .onDelete(perform: removeRecipes)
                }
                .listStyle(.plain)
            }
        }
        .background(Theme.background)
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .redNavigationBar()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if !collection.recipes.isEmpty {
                    RecipeSortMenu(selection: $sort)
                    ShareLink(item: RecipeShareText.make(collection: collection.name, recipes: sortedRecipes),
                              subject: Text(collection.name)) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("Share collection")
                }
                Button {
                    showingAddRecipes = true
                } label: {
                    Image(systemName: "plus")
                }
                .tint(Theme.red)
            }
        }
        .sheet(isPresented: $showingAddRecipes) {
            AddRecipesToCollectionView(collection: collection)
        }
    }

    private func removeRecipes(at offsets: IndexSet) {
        let targets = offsets.map { sortedRecipes[$0] }
        collection.recipes.removeAll { targets.contains($0) }
    }
}
