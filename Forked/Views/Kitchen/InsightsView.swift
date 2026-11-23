// InsightsView.swift
// Kitchen Insights for Chefs: community totals, charts of the top-rated and most-forked recipes, and the latest forks.

import SwiftUI
import SwiftData

struct InsightsView: View {
    @Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]
    @Environment(\.dismiss) private var dismiss

    // Functional: flatMap, map, filter, sorted and reduce derive every figure from the recipe list.
    private var forks: [Recipe] {
        recipes.filter { $0.parent != nil }
    }

    private var allStars: [Int] {
        recipes.flatMap(\.ratings).map(\.stars)
    }

    private var overallAverage: Double? {
        allStars.isEmpty ? nil : Double(allStars.reduce(0, +)) / Double(allStars.count)
    }

    private var topRated: [RecipeBarChart.Entry] {
        recipes.compactMap { recipe in recipe.averageRating.map { RecipeBarChart.Entry(title: recipe.title, value: $0) } }
            .sorted { $0.value > $1.value }
            .prefix(8)
            .map { $0 }
    }

    private var mostForked: [RecipeBarChart.Entry] {
        recipes.filter { !$0.variations.isEmpty }
            .map { RecipeBarChart.Entry(title: $0.title, value: Double($0.variations.count)) }
            .sorted { $0.value > $1.value }
            .prefix(8)
            .map { $0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("What the community is cooking, rating and forking.")
                        .foregroundStyle(Theme.secondaryText)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                        StatTile(value: "\(recipes.count)", label: "Recipes", systemImage: "book.closed")
                        StatTile(value: overallAverage.map { String(format: "%.1f", $0) } ?? "–", label: "Average rating", systemImage: "star")
                        StatTile(value: "\(allStars.count)", label: "Ratings", systemImage: "person.3")
                        StatTile(value: "\(forks.count)", label: "Forks", systemImage: "arrow.triangle.branch")
                    }
                    if !topRated.isEmpty {
                        RecipeBarChart(title: "Top rated", entries: topRated, domain: 0...5) {
                            String(format: "%.1f stars", $0)
                        }
                    }
                    if !mostForked.isEmpty {
                        RecipeBarChart(title: "Most forked", entries: mostForked,
                                       domain: 0...max(mostForked.first?.value ?? 1, 1)) {
                            "\(Int($0)) fork\(Int($0) == 1 ? "" : "s")"
                        }
                    }
                    latestForks
                }
                .padding(24)
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
            .background(Theme.background)
            .navigationTitle("Kitchen Insights")
            .navigationBarTitleDisplayMode(.inline)
            .redNavigationBar()
            .navigationDestination(for: Recipe.self) { RecipeDetailView(recipe: $0) }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }

    private var latestForks: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Latest forks")
            if forks.isEmpty {
                Text("No forks yet.").foregroundStyle(Theme.secondaryText)
            }
            ForEach(forks.prefix(8)) { fork in
                NavigationLink(value: fork) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.triangle.branch")
                            .foregroundStyle(Theme.secondaryText)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fork.title).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.text)
                            Text("Forked from \(fork.parent?.title ?? "a recipe")")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                            if let note = fork.forkNote {
                                ForkNoteView(note: note).font(.caption)
                            }
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right").font(.caption).foregroundStyle(Theme.secondaryText)
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
