// RecipeListView.swift
// The home feed: search by name or ingredient, filter by tag, sort, and browse every recipe.

import SwiftUI
import SwiftData

enum RecipeSearchScope: String, CaseIterable, Identifiable, Hashable {
    case name = "Name"
    case ingredient = "Ingredient"

    var id: String { rawValue }
}

struct RecipeListView: View {
    @Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]
    @State private var searchText = ""
    @State private var scope: RecipeSearchScope = .name
    @State private var selectedTags: Set<String> = []
    @AppStorage(RecipeSort.storageKey) private var sort: RecipeSort = .newest
    @Environment(\.isChef) private var isChef
    @State private var showingInsights = false

    private var allTags: [String] {
        Array(Set(recipes.flatMap(\.tags))).sorted()
    }

    private var filteredRecipes: [Recipe] {
        sort.apply(to: matchingRecipes)
    }

    // PARADIGM: Functional. filter with a closure keeps recipes that match the search and every selected tag.
    private var matchingRecipes: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                switch scope {
                case .name: matchesSearch = recipe.matches(name: searchText)
                case .ingredient: matchesSearch = recipe.matches(ingredient: searchText)
                }
            }
            let matchesTags = selectedTags.isEmpty || !selectedTags.isDisjoint(with: recipe.tags)
            return matchesSearch && matchesTags
        }
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    HomeHeaderBanner()
                    if !allTags.isEmpty {
                        TagChipsView(tags: allTags, selected: $selectedTags)
                    }
                    HStack {
                        Text(searchText.isEmpty && selectedTags.isEmpty ? "THE COLLECTION" : "RESULTS")
                            .font(.caption.weight(.semibold))
                            .tracking(1.8)
                            .foregroundStyle(.secondary)
                        Text("\(filteredRecipes.count)")
                            .font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
                        Spacer()
                        RecipeSortMenu(selection: $sort)
                    }
                    if filteredRecipes.isEmpty {
                        ContentUnavailableView.search.frame(maxWidth: .infinity)
                    } else {
                        LazyVGrid(columns: dynamicTypeSize.isAccessibilitySize ? [GridItem(.flexible())] : [GridItem(.adaptive(minimum: 260), spacing: 28)], spacing: 20) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(value: recipe) { RecipeRowView(recipe: recipe) }
                                    .buttonStyle(.plain)
                                    .recipeActions(recipe)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .frame(maxWidth: 1200)
                .frame(maxWidth: .infinity)
            }
            .background(Theme.background)
            .navigationTitle("Forked")
            .navigationBarTitleDisplayMode(.inline)
            .redNavigationBar()
            .navigationDestination(for: Recipe.self) { recipe in RecipeDetailView(recipe: recipe) }
            .toolbar {
                if isChef {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { showingInsights = true } label: { Image(systemName: "chart.bar.xaxis") }
                            .accessibilityLabel("Kitchen Insights")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) { ShoppingListButton() }
            }
            .sheet(isPresented: $showingInsights) { InsightsView() }
            .searchable(text: $searchText, prompt: scope == .name ? "Search recipes" : "Search ingredients")
            .searchScopes($scope) {
                ForEach(RecipeSearchScope.allCases) { scope in Text(scope.rawValue).tag(scope) }
            }
        }
    }
}
