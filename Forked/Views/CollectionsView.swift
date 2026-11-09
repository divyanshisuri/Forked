import SwiftUI
import SwiftData

struct CollectionsView: View {
    @Query(sort: \RecipeCollection.createdAt) private var collections: [RecipeCollection]
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewCollection = false
    @State private var newCollectionName = ""

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    FavoritesView()
                } label: {
                    Label("Favorites", systemImage: "heart.fill").foregroundStyle(Theme.red)
                }
                ForEach(collections) { collection in
                    NavigationLink(value: collection) {
                        HStack(spacing: 14) {
                            Image(systemName: "folder").font(.title2).foregroundStyle(Theme.red)
                            VStack(alignment: .leading, spacing: 4) {
                            Text(collection.name).font(.headline)
                            Text("\(collection.recipes.count) recipes").font(.caption).foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .onDelete(perform: deleteCollections)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
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
                    .tint(Theme.red)
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
