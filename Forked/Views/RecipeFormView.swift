import SwiftUI
import SwiftData
import PhotosUI

struct RecipeFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let parent: Recipe?

    let editingRecipe: Recipe?
    @State private var draft: RecipeDraft
    @State private var photoItem: PhotosPickerItem?
    @State private var saveError: String?

    init(parent: Recipe? = nil, editingRecipe: Recipe? = nil) {
        self.parent = parent
        self.editingRecipe = editingRecipe
        _draft = State(initialValue: RecipeDraft(recipe: editingRecipe ?? parent, isFork: editingRecipe == nil && parent != nil))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotoPickerPreview(photoItem: $photoItem, photoData: draft.photoData, imageURL: draft.imageURL, height: 190)
                        .listRowInsets(EdgeInsets())
                        .task(id: photoItem) {
                            guard let item = photoItem,
                                  let data = try? await item.loadTransferable(type: Data.self),
                                  !Task.isCancelled else { return }
                            draft.photoData = data
                            draft.imageURL = nil
                        }
                }
                if let parent {
                    Section {
                        Label("Based on \(parent.title)", systemImage: "arrow.triangle.branch")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                Section("Details") {
                    TextField("Recipe title", text: $draft.title)
                    HStack {
                        Label("Cook time", systemImage: "clock").foregroundStyle(.secondary)
                        TextField("Optional", text: $draft.cookTime)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("min").foregroundStyle(.secondary)
                    }
                    if !CookTime.isValid(draft.cookTime) {
                        Text("Enter a whole number from 1 to 1440.")
                            .font(.caption).foregroundStyle(Theme.red)
                    }
                }
                Section("Ingredients") {
                    ForEach(draft.ingredients) { row in
                        HStack {
                            TextField("Ingredient and quantity", text: rowBinding(row.id, in: \.ingredients), axis: .vertical)
                            if draft.ingredients.count > 1 {
                                Button(role: .destructive) {
                                    draft.ingredients.removeAll { $0.id == row.id }
                                } label: { Image(systemName: "minus.circle") }
                                .buttonStyle(.borderless)
                                .accessibilityLabel("Remove ingredient")
                            }
                        }
                    }
                    Button { draft.ingredients.append(.init()) } label: {
                        Label("Add ingredient", systemImage: "plus")
                    }
                }
                Section("Method") {
                    ForEach(Array(draft.steps.enumerated()), id: \.element.id) { index, row in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("\(index + 1)").font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
                            TextField("Describe this step", text: rowBinding(row.id, in: \.steps), axis: .vertical)
                            if draft.steps.count > 1 {
                                Button(role: .destructive) {
                                    draft.steps.removeAll { $0.id == row.id }
                                } label: { Image(systemName: "minus.circle") }
                                .buttonStyle(.borderless)
                                .accessibilityLabel("Remove step")
                            }
                        }
                    }
                    Button { draft.steps.append(.init()) } label: {
                        Label("Add step", systemImage: "plus")
                    }
                }
                Section("Tags") { TagEditorView(tags: $draft.tags) }
            }
            .formStyle(.grouped)
            .navigationTitle(editingRecipe != nil ? "Edit Recipe" : (parent == nil ? "New Recipe" : "Fork Recipe"))
            .navigationBarTitleDisplayMode(.inline)
            .tint(Theme.red)
            .alert("Could not save recipe", isPresented: Binding(get: { saveError != nil }, set: { if !$0 { saveError = nil } })) {
                Button("OK") { saveError = nil }
            } message: {
                Text(saveError ?? "")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .tint(Theme.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingRecipe == nil ? "Post" : "Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!draft.isValid)
                        .opacity(draft.isValid ? 1 : 0.4)
                }
            }
        }
    }

    // Resolve bindings by identity; a removed row can never address a different row.
    private func rowBinding(_ id: UUID, in keyPath: WritableKeyPath<RecipeDraft, [RecipeDraft.Row]>) -> Binding<String> {
        Binding {
            draft[keyPath: keyPath].first { $0.id == id }?.text ?? ""
        } set: { value in
            guard let index = draft[keyPath: keyPath].firstIndex(where: { $0.id == id }) else { return }
            draft[keyPath: keyPath][index].text = value
        }
    }

    private func save() {
        guard draft.isValid else { return }
        do {
            if let editingRecipe {
                guard try draft.save(to: editingRecipe, context: modelContext) else { return }
            } else {
                guard let recipe = draft.makeRecipe(parent: parent) else { return }
                modelContext.insert(recipe)
                try modelContext.save()
            }
            dismiss()
        } catch {
            modelContext.rollback()
            saveError = error.localizedDescription
        }
    }
}
