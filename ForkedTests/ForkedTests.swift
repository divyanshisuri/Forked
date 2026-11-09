import Foundation
import SwiftData
import Testing
@testable import Forked

@MainActor
struct TestStore {
    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init() throws {
        let schema = Schema([Recipe.self, Rating.self, RecipeCollection.self, RecipeVersion.self])
        container = try ModelContainer(for: schema, configurations: [
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        ])
    }

    func recipe() -> Recipe {
        let recipe = Recipe(title: "Soup", ingredients: ["Water", "Salt"], steps: ["Boil", "Serve"], tags: ["Quick"])
        recipe.isUserCreated = true
        recipe.cookTimeMinutes = 20
        context.insert(recipe)
        return recipe
    }
}

@MainActor
struct CookTimeTests {
    @Test(arguments: ["1", "2", "10", "30", "59", "60", "61", "120", "720", "1439", "1440", " 15 ", "001"])
    func valid(text: String) {
        #expect(CookTime.isValid(text))
        #expect(CookTime.minutes(from: text) != nil)
    }
    @Test(arguments: ["0", "-1", "1441", "999999999999999999999999", "1.5", "abc", "1e2", "+1", "1 0", "١", "１２", "NaN", "∞"])
    func invalid(text: String) {
        #expect(!CookTime.isValid(text))
        #expect(CookTime.minutes(from: text) == nil)
    }
    @Test(arguments: ["", " ", "\n", "\t"])
    func optional(text: String) {
        #expect(CookTime.isValid(text))
        #expect(CookTime.minutes(from: text) == nil)
    }
}

@MainActor
struct RecipeDraftTests {
    @Test(arguments: ["", " ", "\n", "\t", " \n "])
    func blankTitles(title: String) throws {
        let store = try TestStore()
        var draft = RecipeDraft(recipe: store.recipe())
        draft.title = title
        #expect(!draft.isValid)
        #expect(draft.makeRecipe() == nil)
    }
    @Test(arguments: [0, 1, 2], [true, false])
    func deletingPreservesIdentity(index: Int, ingredients: Bool) {
        var draft = RecipeDraft()
        let rows = ["Same", "Same", "Last"].map { RecipeDraft.Row(text: $0) }
        let key: WritableKeyPath<RecipeDraft, [RecipeDraft.Row]> = ingredients ? \.ingredients : \.steps
        draft[keyPath: key] = rows
        let removed = rows[index].id
        draft[keyPath: key].removeAll { $0.id == removed }
        #expect(draft[keyPath: key].map(\.id) == rows.filter { $0.id != removed }.map(\.id))
        #expect(Set(rows.map(\.id)).count == 3)
    }
    @Test(arguments: ["1", "1440", "", "0", "1441", "2.5"])
    func validationMatchesCookTime(text: String) throws {
        let store = try TestStore()
        var draft = RecipeDraft(recipe: store.recipe())
        draft.cookTime = text
        #expect(draft.isValid == CookTime.isValid(text))
    }
    @Test func forkCopiesContentAndIsIndependent() throws {
        let store = try TestStore()
        let parent = store.recipe()
        let fork = try #require(RecipeDraft(recipe: parent, isFork: true).makeRecipe(parent: parent))
        #expect(fork.title == "Soup (Fork)")
        #expect(fork.cookTimeMinutes == 20)
        #expect(fork.parent === parent)
        #expect(fork.isUserCreated)
        fork.ingredients.append("Pepper")
        #expect(parent.ingredients == ["Water", "Salt"])
        #expect(fork.ratings.isEmpty)
        #expect(fork.versions.isEmpty)
    }
    @Test func blankRowsAreRemoved() throws {
        var draft = RecipeDraft()
        draft.title = " Soup \n"
        draft.ingredients = [.init(text: " Water "), .init(text: " ")]
        draft.steps = [.init(text: " Boil "), .init(text: "\n")]
        let recipe = try #require(draft.makeRecipe())
        #expect(recipe.title == "Soup")
        #expect(recipe.ingredients == ["Water"])
        #expect(recipe.steps == ["Boil"])
    }
}

@MainActor
struct FavoritesTests {
    @Test(arguments: [true, false], [true, false])
    func persistsWithoutChangingContent(favorite: Bool, owned: Bool) throws {
        let store = try TestStore()
        let recipe = store.recipe()
        recipe.isUserCreated = owned
        let before = RecipeContent(recipe: recipe)
        recipe.isFavorite = favorite
        try store.context.save()
        let context = ModelContext(store.container)
        let fetched = try #require(context.fetch(FetchDescriptor<Recipe>()).first)
        #expect(fetched.isFavorite == favorite)
        #expect(RecipeContent(recipe: fetched) == before)
        #expect(fetched.versions.isEmpty)
    }
    @Test func favoriteNotInherited() throws {
        let store = try TestStore()
        let parent = store.recipe()
        parent.isFavorite = true
        let fork = try #require(RecipeDraft(recipe: parent).makeRecipe(parent: parent))
        #expect(!fork.isFavorite)
    }
}

@MainActor
struct RecipeDiffTests {
    @Test(arguments: ["Title", "Ingredients", "Steps", "Tags", "Cook time", "Photo"])
    func detectsField(field: String) throws {
        let store = try TestStore()
        let original = RecipeContent(recipe: store.recipe())
        var changed = original
        switch field {
        case "Title": changed.title = "New"
        case "Ingredients": changed.ingredients.append("Pepper")
        case "Steps": changed.steps.reverse()
        case "Tags": changed.tags = []
        case "Cook time": changed.cookTimeMinutes = nil
        default: changed.photoData = Data([1, 2])
        }
        let diff = RecipeDiff(original: original, variation: changed)
        #expect(diff.changes.count == 1)
        #expect(diff.changes.first?.field == field)
        #expect(diff.summary.contains(field))
    }
    @Test func identicalContent() throws {
        let store = try TestStore()
        let content = RecipeContent(recipe: store.recipe())
        #expect(RecipeDiff(original: content, variation: content).changes.isEmpty)
    }
    @Test func duplicatesAndOrderingMatter() throws {
        let store = try TestStore()
        var original = RecipeContent(recipe: store.recipe())
        original.ingredients = ["Salt", "Salt", "Water"]
        var changed = original
        changed.ingredients = ["Salt", "Water"]
        #expect(RecipeDiff(original: original, variation: changed).changes.count == 1)
        changed.ingredients = ["Water", "Salt", "Salt"]
        #expect(RecipeDiff(original: original, variation: changed).changes.count == 1)
    }
}

@MainActor
struct RecipeEditTests {
    @Test(arguments: ["New", " Soup 2 ", "🍲"], [true, false])
    func ownershipEnforced(title: String, owned: Bool) throws {
        let store = try TestStore()
        let recipe = store.recipe()
        recipe.isUserCreated = owned
        var draft = RecipeDraft(recipe: recipe)
        draft.title = title
        let saved = try draft.save(to: recipe, context: store.context)
        #expect(saved == owned)
        #expect(recipe.title == (owned ? title.trimmingCharacters(in: .whitespacesAndNewlines) : "Soup"))
        #expect(recipe.versions.count == (owned ? 1 : 0))
    }
    @Test(arguments: ["", " ", "0", "1441", "abc"])
    func invalidEditsAreRejected(value: String) throws {
        let store = try TestStore()
        let recipe = store.recipe()
        var draft = RecipeDraft(recipe: recipe)
        if value.trimmingCharacters(in: .whitespaces).isEmpty { draft.title = value }
        else { draft.cookTime = value }
        #expect(try draft.save(to: recipe, context: store.context) == false)
        #expect(recipe.title == "Soup")
        #expect(recipe.versions.isEmpty)
    }
    @Test func editPreservesRelationships() throws {
        let store = try TestStore()
        let recipe = store.recipe()
        let fork = try #require(RecipeDraft(recipe: recipe).makeRecipe(parent: recipe))
        store.context.insert(fork)
        let rating = Rating(stars: 4, isOwn: true, recipe: recipe)
        store.context.insert(rating)
        recipe.isFavorite = true
        let date = recipe.createdAt
        var draft = RecipeDraft(recipe: recipe)
        draft.title = "Edited"
        try draft.save(to: recipe, context: store.context)
        #expect(fork.title == "Soup")
        #expect(fork.parent === recipe)
        #expect(recipe.ownRating?.stars == 4)
        #expect(recipe.isFavorite)
        #expect(recipe.createdAt == date)
    }
}

@MainActor
struct RecipeVersionTests {
    @Test(arguments: ["title", "ingredients", "steps", "tags", "photo", "url", "time"])
    func snapshotPersists(field: String) throws {
        let store = try TestStore()
        let recipe = store.recipe()
        let original = RecipeContent(recipe: recipe)
        var draft = RecipeDraft(recipe: recipe)
        switch field {
        case "title": draft.title = "Updated"
        case "ingredients": draft.ingredients.append(.init(text: "Pepper"))
        case "steps": draft.steps.reverse()
        case "tags": draft.tags = ["New"]
        case "photo": draft.photoData = Data([4, 5])
        case "url": draft.imageURL = "https://example.com/photo.jpg"
        default: draft.cookTime = "40"
        }
        try draft.save(to: recipe, context: store.context)
        #expect(recipe.versions.count == 1)
        #expect(recipe.versions.first?.content == original)
        let context = ModelContext(store.container)
        #expect(try context.fetch(FetchDescriptor<RecipeVersion>()).first?.content == original)
    }
    @Test func noOpDoesNotCreateVersion() throws {
        let store = try TestStore()
        let recipe = store.recipe()
        try RecipeDraft(recipe: recipe).save(to: recipe, context: store.context)
        #expect(recipe.versions.isEmpty)
    }
    @Test func successiveEditsPreserveEverySnapshot() throws {
        let store = try TestStore()
        let recipe = store.recipe()
        for title in ["Second", "Third", "Fourth"] {
            var draft = RecipeDraft(recipe: recipe)
            draft.title = title
            try draft.save(to: recipe, context: store.context)
        }
        #expect(Set(recipe.versions.map { $0.content.title }) == Set(["Soup", "Second", "Third"]))
    }
    @Test func deletingRecipeCascadesHistory() throws {
        let store = try TestStore()
        let recipe = store.recipe()
        var draft = RecipeDraft(recipe: recipe)
        draft.title = "Updated"
        try draft.save(to: recipe, context: store.context)
        store.context.delete(recipe)
        try store.context.save()
        #expect(try store.context.fetchCount(FetchDescriptor<RecipeVersion>()) == 0)
    }
}
