// DiscoverView.swift
// Live recipes from TheMealDB with search, pull to refresh, a loading state and an offline fallback.

import SwiftUI

struct DiscoverView: View {
    let model: DiscoverModel
    @State private var query = ""
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var columns: [GridItem] {
        dynamicTypeSize.isAccessibilitySize ? [GridItem(.flexible())] : [GridItem(.adaptive(minimum: 220), spacing: 20)]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    if let since = model.offlineSince {
                        OfflineBanner(savedAt: since) { Task { await model.loadFeed() } }
                    }
                    content
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .frame(maxWidth: 1200)
                .frame(maxWidth: .infinity)
            }
            .background(Theme.background)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .redNavigationBar()
            .navigationDestination(for: WebRecipe.self) { WebRecipeDetailView(webRecipe: $0) }
            .navigationDestination(for: Recipe.self) { RecipeDetailView(recipe: $0) }
            .searchable(text: $query, prompt: "Search recipes online")
            .onSubmit(of: .search) { Task { await model.search(query) } }
            .onChange(of: query) { _, newValue in
                if newValue.isEmpty && !model.activeQuery.isEmpty { Task { await model.loadFeed() } }
            }
            .refreshable { await model.loadFeed() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await model.loadFeed() } } label: { Image(systemName: "arrow.clockwise") }
                        .disabled(model.phase == .loading)
                        .accessibilityLabel("Get new recipes")
                }
            }
            .task { if model.phase == .idle { await model.loadFeed() } }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.activeQuery.isEmpty ? "Fresh from the web" : "Results for “\(model.activeQuery)”")
                .font(.largeTitle)
                .fontDesign(.serif)
                .foregroundStyle(Theme.text)
            Text("New picks every refresh. Save one to your cookbook to cook, scale and fork it.")
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
        }
        .padding(.top, 16)
    }

    @ViewBuilder private var content: some View {
        switch model.phase {
        case .idle:
            LoadingCardsView(columns: columns)
        case .loading where model.recipes.isEmpty:
            LoadingCardsView(columns: columns)
        case .failed(let message):
            ContentUnavailableView {
                Label("Can't Reach Recipes", systemImage: "wifi.slash")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await model.loadFeed() } }.buttonStyle(.red)
            }
        default:
            if model.recipes.isEmpty {
                ContentUnavailableView.search(text: model.activeQuery)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(model.recipes) { recipe in
                        NavigationLink(value: recipe) { WebRecipeCard(recipe: recipe) }
                            .buttonStyle(.plain)
                    }
                }
                .opacity(model.phase == .loading ? 0.4 : 1)
                .overlay { if model.phase == .loading { ProgressView("Loading…") } }
                .animation(.default, value: model.phase)
            }
        }
    }
}
