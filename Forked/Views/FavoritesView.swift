import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(filter: #Predicate<Recipe> { $0.isFavorite }, sort: \Recipe.createdAt, order: .reverse)
    private var recipes: [Recipe]

    var body: some View {
        List(recipes) { recipe in
            NavigationLink(value: recipe) { RecipeRowView(recipe: recipe) }
                .listRowSeparator(.hidden)
        }
        .overlay {
            if recipes.isEmpty {
                ContentUnavailableView("No Favorites", systemImage: "heart", description: Text("Tap the heart on a recipe to save it here."))
            }
        }
        .navigationTitle("Favorites")
        .redNavigationBar()
    }
}
