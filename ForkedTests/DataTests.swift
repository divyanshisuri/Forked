// DataTests.swift
// Unit tests for the sample data and the shopping list.

import Foundation
import SwiftData
import Testing
@testable import Forked

@MainActor
struct SeedDataTests {
    @Test func seedsTheWholeCatalogWithPhotosAndServings() throws {
        let container = try TestSupport.makeContainer()
        SeedData.seedIfNeeded(context: container.mainContext, defaults: TestSupport.makeDefaults())
        let recipes = try container.mainContext.fetch(FetchDescriptor<Recipe>())
        #expect(recipes.count == SeedCatalog.recipes.count)
        #expect(recipes.allSatisfy { $0.imageURL != nil && $0.servings != nil })
        #expect(recipes.filter { $0.parent != nil }.allSatisfy { $0.forkNote != nil })
    }

    @Test func runsOncePerCatalogVersion() throws {
        let container = try TestSupport.makeContainer()
        let defaults = TestSupport.makeDefaults()
        SeedData.seedIfNeeded(context: container.mainContext, defaults: defaults)
        let recipe = try #require(try container.mainContext.fetch(FetchDescriptor<Recipe>()).first)
        container.mainContext.delete(recipe)
        try container.mainContext.save()
        SeedData.seedIfNeeded(context: container.mainContext, defaults: defaults)
        #expect(try container.mainContext.fetchCount(FetchDescriptor<Recipe>()) == SeedCatalog.recipes.count - 1)
    }

    @Test func seedsFourChefsAndFourConsumers() throws {
        let container = try TestSupport.makeContainer()
        SeedData.seedUsersIfNeeded(context: container.mainContext)
        let users = try container.mainContext.fetch(FetchDescriptor<User>())
        #expect(users.count == 8)
        #expect(users.filter { $0.role == .chef }.count == 4)
    }
}

@MainActor
struct ShoppingListTests {
    @Test func scalesAndSkipsDuplicates() throws {
        let container = try TestSupport.makeContainer()
        let context = container.mainContext
        let recipe = Recipe(title: "Toast", ingredients: ["2 slices bread", "1 tbsp butter"], steps: ["Toast."])
        context.insert(recipe)
        #expect(try ShoppingList.add(recipe, factor: 2, context: context) == 2)
        #expect(try ShoppingList.add(recipe, factor: 2, context: context) == 0)
        let items = try context.fetch(FetchDescriptor<ShoppingItem>())
        #expect(Set(items.map(\.text)) == ["4 slices bread", "2 tbsp butter"])
    }

    @Test func shareTextListsItems() {
        let text = ShoppingList.text(for: [ShoppingItem(text: "2 eggs")])
        #expect(text.contains("☐ 2 eggs"))
    }
}
