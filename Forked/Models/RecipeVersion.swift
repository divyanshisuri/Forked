import Foundation
import SwiftData
@Model
final class RecipeVersion {
    var savedAt: Date = Date.now
    var content: RecipeContent
    var recipe: Recipe?

    init(content: RecipeContent, recipe: Recipe) {
        self.content = content
        self.recipe = recipe
    }
}
