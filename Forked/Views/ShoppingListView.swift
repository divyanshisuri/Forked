// ShoppingListView.swift
// The shopping list, grouped by recipe, with check-off, add, share and clear.

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Query(sort: \ShoppingItem.createdAt) private var items: [ShoppingItem]
    @Environment(\.modelContext) private var modelContext
    @State private var newItem = ""
    @State private var saveError: String?

    private var groups: [(title: String, items: [ShoppingItem])] {
        var order: [String] = []
        var grouped: [String: [ShoppingItem]] = [:]
        for item in items {
            let key = item.recipeTitle ?? "Other"
            if grouped[key] == nil { order.append(key) }
            grouped[key, default: []].append(item)
        }
        return order.map { ($0, grouped[$0] ?? []) }
    }

    private var remaining: [ShoppingItem] { items.filter { !$0.isChecked } }

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "plus").foregroundStyle(Theme.secondaryText)
                    TextField("Add an item", text: $newItem)
                        .submitLabel(.done)
                        .onSubmit(addItem)
                }
            }
            ForEach(groups, id: \.title) { group in
                Section(group.title) {
                    ForEach(group.items) { item in
                        ShoppingItemRow(item: item) { persist() }
                    }
                    .onDelete { offsets in delete(offsets.map { group.items[$0] }) }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Theme.background)
        .overlay {
            if items.isEmpty {
                ContentUnavailableView("Your List Is Empty", systemImage: "cart",
                                       description: Text("Add ingredients from any recipe, or type an item above."))
            }
        }
        .navigationTitle("Shopping List")
        .redNavigationBar()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ShareLink(item: ShoppingList.text(for: remaining)) {
                        Label("Share List", systemImage: "square.and.arrow.up")
                    }
                    .disabled(remaining.isEmpty)
                    Button { delete(items.filter(\.isChecked)) } label: {
                        Label("Clear Checked", systemImage: "checkmark.circle")
                    }
                    .disabled(remaining.count == items.count)
                    Button(role: .destructive) { delete(items) } label: {
                        Label("Clear All", systemImage: "trash")
                    }
                    .disabled(items.isEmpty)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityLabel("List options")
            }
        }
        .alert("Could not update list", isPresented: Binding(get: { saveError != nil }, set: { if !$0 { saveError = nil } })) {
            Button("OK") { saveError = nil }
        } message: { Text(saveError ?? "") }
    }

    private func addItem() {
        let text = newItem.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        modelContext.insert(ShoppingItem(text: text))
        newItem = ""
        persist()
    }

    private func delete(_ targets: [ShoppingItem]) {
        targets.forEach(modelContext.delete)
        persist()
    }

    private func persist() {
        do { try modelContext.save() } catch {
            modelContext.rollback()
            saveError = error.localizedDescription
        }
    }
}
