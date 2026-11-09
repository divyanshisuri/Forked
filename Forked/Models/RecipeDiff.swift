import Foundation
struct RecipeDiff {
    struct Change: Identifiable {
        var id: String { field }
        let field: String
        let before: String
        let after: String
    }
    let changes: [Change]
    var summary: String {
        changes.isEmpty ? "No changes" : "Changed: " + changes.map(\.field).joined(separator: ", ")
    }
    init(original: RecipeContent, variation: RecipeContent) {
        var result: [Change] = []
        func compare(_ field: String, _ before: String, _ after: String) {
            if before != after { result.append(Change(field: field, before: before, after: after)) }
        }
        compare("Title", original.title, variation.title)
        compare("Ingredients", original.ingredients.joined(separator: "\n"), variation.ingredients.joined(separator: "\n"))
        compare("Steps", original.steps.joined(separator: "\n"), variation.steps.joined(separator: "\n"))
        compare("Tags", original.tags.joined(separator: ", "), variation.tags.joined(separator: ", "))
        compare("Cook time", original.cookTimeMinutes.map(CookTime.label) ?? "Not specified",
                variation.cookTimeMinutes.map(CookTime.label) ?? "Not specified")
        if original.photoData != variation.photoData || original.imageURL != variation.imageURL {
            result.append(Change(field: "Photo", before: "Original photo", after: "Photo changed"))
        }
        changes = result
    }
}
