// RecipeDraft.swift
// Editable form state for creating, forking or editing a recipe, with validation and saving.

import Foundation
import SwiftData

struct RecipeDraft {
    struct Row: Identifiable, Equatable {
        let id = UUID()
        var text: String = ""
    }
    var title = ""
    var ingredients = [Row()]
    var steps = [Row()]
    var tags: [String] = []
    var photoData: Data?
    var imageURL: String?
    var cookTime = ""
    var servings = ""
    var forkNote = ""

    init(recipe: Recipe? = nil, isFork: Bool = false) {
        guard let recipe else { return }
        title = recipe.title + (isFork ? " (Fork)" : "")
        ingredients = recipe.ingredients.isEmpty ? [Row()] : recipe.ingredients.map { Row(text: $0) }
        steps = recipe.steps.isEmpty ? [Row()] : recipe.steps.map { Row(text: $0) }
        tags = recipe.tags
        photoData = recipe.photoData
        imageURL = recipe.imageURL
        cookTime = recipe.cookTimeMinutes.map(String.init) ?? ""
        servings = recipe.servings.map(String.init) ?? ""
        forkNote = isFork ? "" : recipe.forkNote ?? ""
    }
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        CookTime.isValid(cookTime) && Servings.isValid(servings) &&
        !cleaned(ingredients).isEmpty && !cleaned(steps).isEmpty
    }
    private func cleaned(_ rows: [Row]) -> [String] {
        rows.map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }
    func makeRecipe(parent: Recipe? = nil) -> Recipe? {
        guard isValid else { return nil }
        let recipe = Recipe(parent: parent)
        apply(to: recipe)
        recipe.isUserCreated = true
        return recipe
    }
    private func apply(to recipe: Recipe) {
        recipe.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        recipe.ingredients = cleaned(ingredients)
        recipe.steps = cleaned(steps)
        recipe.tags = tags
        recipe.photoData = photoData
        recipe.imageURL = imageURL
        recipe.cookTimeMinutes = CookTime.minutes(from: cookTime)
        recipe.servings = Servings.count(from: servings)
        let note = forkNote.trimmingCharacters(in: .whitespacesAndNewlines)
        recipe.forkNote = recipe.parent == nil || note.isEmpty ? nil : note
    }
    /// Applies the draft and records the previous content as a version when anything changed.
    @discardableResult
    func save(to recipe: Recipe, context: ModelContext) throws -> Bool {
        guard isValid, recipe.isUserCreated else { return false }
        let previous = RecipeContent(recipe: recipe)
        apply(to: recipe)
        if previous != RecipeContent(recipe: recipe) {
            let version = RecipeVersion(content: previous, recipe: recipe)
            context.insert(version)
            recipe.versions.append(version)
        }
        try context.save()
        return true
    }
}
