// ShoppingListButton.swift
// Toolbar cart button with a badge counting unchecked items; opens the shopping list in a sheet.

import SwiftUI
import SwiftData

struct ShoppingListButton: View {
    @Query(filter: #Predicate<ShoppingItem> { !$0.isChecked }) private var remaining: [ShoppingItem]
    @State private var showingList = false

    var body: some View {
        Button { showingList = true } label: {
            Image(systemName: "cart")
                .overlay(alignment: .topTrailing) {
                    if !remaining.isEmpty {
                        Text("\(min(remaining.count, 99))")
                            .font(.caption2.weight(.bold).monospacedDigit())
                            .foregroundStyle(Theme.onAccent)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(Theme.red, in: Capsule())
                            .offset(x: 10, y: -8)
                    }
                }
        }
        .accessibilityLabel("Shopping list, \(remaining.count) items")
        .sheet(isPresented: $showingList) {
            NavigationStack {
                ShoppingListView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { showingList = false }
                        }
                    }
            }
        }
    }
}
