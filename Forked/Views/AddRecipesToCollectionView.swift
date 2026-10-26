import SwiftUI
import SwiftData

struct AddRecipesToCollectionView: View {
    @Bindable var collection: RecipeCollection
    @Query(sort: \Recipe.title) private var allRecipes: [Recipe]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(allRecipes) { recipe in
                Button {
                    toggle(recipe)
                } label: {
                    HStack {
                        Text(recipe.title)
                            .foregroundStyle(Theme.text)
                        Spacer()
                        if collection.recipes.contains(recipe) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.red)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Add Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .redNavigationBar()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .tint(.white)
                }
            }
        }
    }

    private func toggle(_ recipe: Recipe) {
        if let index = collection.recipes.firstIndex(of: recipe) {
            collection.recipes.remove(at: index)
        } else {
            collection.recipes.append(recipe)
        }
    }
}
