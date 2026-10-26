import SwiftUI
import SwiftData

struct CollectionDetailView: View {
    @Bindable var collection: RecipeCollection
    @State private var showingAddRecipes = false

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
                    ForEach(collection.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeRowView(recipe: recipe)
                        }
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
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddRecipes = true
                } label: {
                    Image(systemName: "plus")
                }
                .tint(.white)
            }
        }
        .sheet(isPresented: $showingAddRecipes) {
            AddRecipesToCollectionView(collection: collection)
        }
    }

    private func removeRecipes(at offsets: IndexSet) {
        for index in offsets {
            collection.recipes.remove(at: index)
        }
    }
}
