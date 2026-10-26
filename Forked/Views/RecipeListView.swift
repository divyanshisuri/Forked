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
    @State private var showingForm = false

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

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 0) {
                        HomeHeaderBanner()

                        VStack(spacing: 16) {
                            if !allTags.isEmpty {
                                TagChipsView(tags: allTags, selected: $selectedTags)
                                    .padding(.horizontal)
                            }

                            if filteredRecipes.isEmpty {
                                ContentUnavailableView.search
                                    .padding(.top, 60)
                            } else {
                                LazyVStack(spacing: 16) {
                                    ForEach(filteredRecipes) { recipe in
                                        NavigationLink(value: recipe) {
                                            RecipeRowView(recipe: recipe)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }

                Button {
                    showingForm = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Theme.red)
                        .clipShape(Circle())
                        .shadow(color: Theme.red.opacity(0.4), radius: 8, y: 4)
                }
                .padding(20)
            }
            .background(Theme.background)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .redNavigationBar()
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .searchable(text: $searchText, prompt: scope == .name ? "Search recipes" : "Search by ingredient")
            .searchScopes($scope) {
                ForEach(RecipeSearchScope.allCases) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.white)
                }
            }
            .fullScreenCover(isPresented: $showingForm) {
                RecipeFormView(parent: nil)
            }
        }
    }
}
