// CookModeView.swift
// Full-screen, hands-free cooking: an ingredient checklist, then one step per page with timers. Keeps the screen awake.

import SwiftUI
import UIKit
import SwiftData

struct CookModeView: View {
    let recipe: Recipe
    var factor: Double = 1
    @Environment(\.dismiss) private var dismiss
    @State private var page = 0
    @State private var timerEnds: [Int: Date] = [:]
    @State private var gathered: Set<Int> = []

    private var lastPage: Int { recipe.steps.count }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(page), total: Double(max(lastPage, 1)))
                    .tint(Theme.red)
                    .padding(.horizontal, 24)
                    .accessibilityLabel(page == 0 ? "Ingredients" : "Step \(page) of \(lastPage)")
                TabView(selection: $page) {
                    CookIngredientsPage(
                        ingredients: recipe.ingredients.map { IngredientScaler.scale($0, by: factor) },
                        gathered: $gathered
                    )
                    .tag(0)
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        CookStepPage(number: index + 1, total: recipe.steps.count, text: step, recipeTitle: recipe.title,
                                     notificationID: notificationID(index), timerEnd: timerBinding(index))
                            .tag(index + 1)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                CookTimersBar(timerEnds: timerEnds) { page = $0 + 1 }
                controls
            }
            .background(Theme.background)
            .navigationTitle(recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .tint(Theme.red)
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            TimerNotifier.cancel(ids: recipe.steps.indices.map(notificationID))
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation { page -= 1 }
            } label: {
                Label("Back", systemImage: "chevron.left").frame(maxWidth: .infinity)
            }
            .buttonStyle(.outline)
            .disabled(page == 0)
            Button {
                if page == lastPage { dismiss() } else { withAnimation { page += 1 } }
            } label: {
                Text(page == 0 ? "Start" : page == lastPage ? "Finish" : "Next Step").frame(maxWidth: .infinity)
            }
            .buttonStyle(.red)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .sensoryFeedback(.selection, trigger: page)
    }

    private func notificationID(_ index: Int) -> String {
        "cook-\(recipe.persistentModelID.hashValue)-\(index)"
    }

    private func timerBinding(_ index: Int) -> Binding<Date?> {
        Binding { timerEnds[index] } set: { timerEnds[index] = $0 }
    }
}
