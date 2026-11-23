// RecipeHelperTests.swift
// Unit tests for ingredient scaling, step timer parsing, recipe sorting and form validation.

import Testing
@testable import Forked

@MainActor
struct IngredientScalerTests {
    @Test(arguments: [
        ("1 1/2 cups lentils", 2.0, "3 cups lentils"),
        ("1/2 tsp salt", 0.5, "¼ tsp salt"),
        ("2-3 cloves garlic", 2.0, "4–6 cloves garlic"),
        ("½ cup milk", 3.0, "1½ cup milk"),
        ("12 oz fettuccine", 1.5, "18 oz fettuccine"),
        ("Pizza dough", 2.0, "Pizza dough"),
        ("2 eggs", 1.0, "2 eggs")
    ])
    func scales(input: String, factor: Double, expected: String) {
        #expect(IngredientScaler.scale(input, by: factor) == expected)
    }

    @Test func ignoresWordsThatLookLikeNumbers() {
        #expect(IngredientScaler.scale("nan bread", by: 2) == "nan bread")
    }
}

@MainActor
struct StepDurationTests {
    @Test func readsMinutesAndUsesLowerBoundOfARange() {
        #expect(StepDuration.minutes(in: "Bake at 500°F for 8-10 minutes until golden.") == 8)
    }

    @Test func convertsHoursToMinutes() {
        #expect(StepDuration.minutes(in: "Soak for at least 1 hour.") == 60)
    }

    @Test func returnsNilWithoutATime() {
        #expect(StepDuration.minutes(in: "Stir well.") == nil)
    }
}

@MainActor
struct RecipeSortTests {
    @Test func quickestPutsRecipesWithoutATimeLast() {
        let slow = Recipe(title: "Slow")
        slow.cookTimeMinutes = 60
        let fast = Recipe(title: "Fast")
        fast.cookTimeMinutes = 5
        let unknown = Recipe(title: "Unknown")
        #expect(RecipeSort.quickest.apply(to: [unknown, slow, fast]).map(\.title) == ["Fast", "Slow", "Unknown"])
    }

    @Test func alphabeticalIgnoresCase() {
        let titles = RecipeSort.alphabetical.apply(to: [Recipe(title: "banana"), Recipe(title: "Apple")]).map(\.title)
        #expect(titles == ["Apple", "banana"])
    }
}

@MainActor
struct RecipeDraftTests {
    @Test func requiresTitleIngredientAndStep() {
        var draft = RecipeDraft()
        #expect(!draft.isValid)
        draft.title = "Toast"
        draft.ingredients = [.init(text: "1 slice bread")]
        draft.steps = [.init(text: "Toast it.")]
        #expect(draft.isValid)
    }

    @Test func rejectsOutOfRangeCookTimeAndServings() {
        var draft = RecipeDraft()
        draft.title = "Toast"
        draft.ingredients = [.init(text: "bread")]
        draft.steps = [.init(text: "Toast it.")]
        draft.cookTime = "0"
        #expect(!draft.isValid)
        draft.cookTime = "5"
        draft.servings = "500"
        #expect(!draft.isValid)
    }

    @Test func forkStartsWithEmptyNoteAndForkTitle() {
        let original = Recipe(title: "Soup", ingredients: ["water"], steps: ["Boil."])
        original.forkNote = "Original note"
        let draft = RecipeDraft(recipe: original, isFork: true)
        #expect(draft.title == "Soup (Fork)")
        #expect(draft.forkNote.isEmpty)
    }
}
