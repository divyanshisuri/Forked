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

    private var allTags: [String] {
        Array(Set(recipes.flatMap(\.tags))).sorted()
    }

    private var filteredRecipes: [Recipe] {
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
                        Spacer()
                        Text("\(filteredRecipes.count)")
                            .font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
                    }
                    if filteredRecipes.isEmpty {
                        ContentUnavailableView.search.frame(maxWidth: .infinity)
                    } else {
                        LazyVGrid(columns: dynamicTypeSize.isAccessibilitySize ? [GridItem(.flexible())] : [GridItem(.adaptive(minimum: 260), spacing: 28)], spacing: 20) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(value: recipe) { RecipeRowView(recipe: recipe) }
                                    .buttonStyle(.plain)
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
            .searchable(text: $searchText, prompt: scope == .name ? "Search recipes" : "Search ingredients")
            .searchScopes($scope) {
                ForEach(RecipeSearchScope.allCases) { scope in Text(scope.rawValue).tag(scope) }
            }
        }
    }
}
