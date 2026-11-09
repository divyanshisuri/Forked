import Foundation
nonisolated struct RecipeContent: Codable, Equatable, Sendable {
    var title: String
    var ingredients: [String]
    var steps: [String]
    var tags: [String]
    var photoData: Data?
    var imageURL: String?
    var cookTimeMinutes: Int?

    @MainActor
    init(recipe: Recipe) {
        title = recipe.title
        ingredients = recipe.ingredients
        steps = recipe.steps
        tags = recipe.tags
        photoData = recipe.photoData
        imageURL = recipe.imageURL
        cookTimeMinutes = recipe.cookTimeMinutes
    }
}
