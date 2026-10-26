import SwiftUI
import SwiftData
import PhotosUI

struct RecipeFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let parent: Recipe?

    @State private var title: String
    @State private var ingredients: [String]
    @State private var steps: [String]
    @State private var tags: [String]
    @State private var photoData: Data?
    @State private var imageURL: String?
    @State private var photoItem: PhotosPickerItem?

    init(parent: Recipe?) {
        self.parent = parent
        if let parent {
            _title = State(initialValue: "\(parent.title) (Fork)")
            _ingredients = State(initialValue: parent.ingredients)
            _steps = State(initialValue: parent.steps)
            _tags = State(initialValue: parent.tags)
            _photoData = State(initialValue: parent.photoData)
            _imageURL = State(initialValue: parent.imageURL)
        } else {
            _title = State(initialValue: "")
            _ingredients = State(initialValue: [""])
            _steps = State(initialValue: [""])
            _tags = State(initialValue: [])
            _photoData = State(initialValue: nil)
            _imageURL = State(initialValue: nil)
        }
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        ingredients.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty } &&
        steps.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    PhotoPickerPreview(photoItem: $photoItem, photoData: photoData, imageURL: imageURL)
                        .onChange(of: photoItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    photoData = data
                                    imageURL = nil
                                }
                            }
                        }

                    if let parent {
                        Label("Forking \"\(parent.title)\"", systemImage: "arrow.triangle.branch")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.red)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader("Title")
                        TextField("Recipe title", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Ingredients")
                        ForEach(ingredients.indices, id: \.self) { index in
                            HStack {
                                TextField("Ingredient", text: $ingredients[index])
                                    .textFieldStyle(.roundedBorder)
                                if ingredients.count > 1 {
                                    Button {
                                        ingredients.remove(at: index)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(Theme.red)
                                    }
                                }
                            }
                        }
                        Button {
                            ingredients.append("")
                        } label: {
                            Label("Add Ingredient", systemImage: "plus")
                        }
                        .buttonStyle(.red)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Steps")
                        ForEach(steps.indices, id: \.self) { index in
                            HStack(alignment: .top) {
                                TextField("Step \(index + 1)", text: $steps[index], axis: .vertical)
                                    .textFieldStyle(.roundedBorder)
                                if steps.count > 1 {
                                    Button {
                                        steps.remove(at: index)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(Theme.red)
                                    }
                                }
                            }
                        }
                        Button {
                            steps.append("")
                        } label: {
                            Label("Add Step", systemImage: "plus")
                        }
                        .buttonStyle(.red)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Tags")
                        TagEditorView(tags: $tags)
                    }
                }
                .padding()
            }
            .navigationTitle(parent == nil ? "New Post" : "Fork Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .tint(Theme.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") { save() }
                        .buttonStyle(.red)
                        .disabled(!isValid)
                        .opacity(isValid ? 1 : 0.4)
                }
            }
        }
    }

    private func save() {
        let recipe = Recipe(
            title: title.trimmingCharacters(in: .whitespaces),
            ingredients: ingredients.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
            steps: steps.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
            tags: tags,
            photoData: photoData,
            imageURL: imageURL,
            parent: parent
        )
        modelContext.insert(recipe)
        dismiss()
    }
}
