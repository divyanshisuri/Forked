import Foundation
import SwiftData

@Model
final class Rating {
    var stars: Int
    var isOwn: Bool
    var createdAt: Date
    var recipe: Recipe?

    init(stars: Int, isOwn: Bool = false, createdAt: Date = .now, recipe: Recipe? = nil) {
        self.stars = min(max(stars, 1), 5)
        self.isOwn = isOwn
        self.createdAt = createdAt
        self.recipe = recipe
    }
}
