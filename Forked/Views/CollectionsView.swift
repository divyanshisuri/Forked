import SwiftUI
import SwiftData

struct CollectionsView: View {
    @Query(sort: \RecipeCollection.createdAt) private var collections: [RecipeCollection]
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewCollection = false
    @State private var newCollectionName = ""

    var body: some View {
        NavigationStack {
            Group {
                if collections.isEmpty {
                    ContentUnavailableView(
                        "No Collections",
                        systemImage: "folder",
                        description: Text("Create a collection to save your favorite recipes.")
                    )
                } else {
                    List {
                        ForEach(collections) { collection in
                            NavigationLink(value: collection) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(collection.name)
                                        .font(.headline)
                                        .foregroundStyle(Theme.text)
                                    Text("\(collection.recipes.count) recipe\(collection.recipes.count == 1 ? "" : "s")")
                                        .font(.caption)
                                        .foregroundStyle(Theme.secondaryText)
                                }
                            }
                        }
                        .onDelete(perform: deleteCollections)
                    }
                    .listStyle(.plain)
                }
            }
            .background(Theme.background)
            .navigationTitle("Collections")
            .redNavigationBar()
            .navigationDestination(for: RecipeCollection.self) { collection in
                CollectionDetailView(collection: collection)
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewCollection = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.white)
                }
            }
            .alert("New Collection", isPresented: $showingNewCollection) {
                TextField("Name", text: $newCollectionName)
                Button("Cancel", role: .cancel) { newCollectionName = "" }
                Button("Create") { createCollection() }
            }
        }
    }

    private func createCollection() {
        let trimmed = newCollectionName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        modelContext.insert(RecipeCollection(name: trimmed))
        newCollectionName = ""
    }

    private func deleteCollections(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(collections[index])
        }
    }
}
