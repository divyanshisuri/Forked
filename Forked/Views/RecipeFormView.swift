// RecipeFormView.swift
// Create, fork or edit a recipe. One column on iPhone, two columns on wide iPad and Mac windows.

import SwiftUI
import SwiftData
import PhotosUI
import UIKit

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

    private static let twoColumnMinWidth: CGFloat = 700

    private var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }

    var body: some View {
        if #available(iOS 18.0, *) {
            if isPhone {
                navigationContent
            } else {
                navigationContent
                    .frame(idealWidth: 1000, idealHeight: 800)
                    .presentationSizing(.fitted)
            }
        } else {
            navigationContent
        }
    }

    // Checked by device, not size class: large iPhones report a regular width in landscape.
    @ViewBuilder private var layout: some View {
        if isPhone {
            singleColumnForm
        } else {
            GeometryReader { proxy in
                if proxy.size.width >= Self.twoColumnMinWidth {
                    twoColumnForm(width: proxy.size.width)
                } else {
                    singleColumnForm
                }
            }
        }
    }

    private var singleColumnForm: some View {
        Form {
            photoSection(height: 190)
            parentSection
            detailsSection
            ingredientsSection
            methodSection
            tagsSection
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .background(Theme.background)
    }

    private func twoColumnForm(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            Form {
                photoSection(height: 260)
                parentSection
                detailsSection
                tagsSection
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .frame(width: min(width * 0.4, 440))
            Divider()
            Form {
                ingredientsSection
                methodSection
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
        .background(Theme.background)
    }

    private func photoSection(height: CGFloat) -> some View {
        Section {
            PhotoPickerPreview(photoItem: $photoItem, photoData: draft.photoData, imageURL: draft.imageURL, height: height)
                .listRowInsets(EdgeInsets())
        }
    }

    @ViewBuilder private var parentSection: some View {
        if let base = parent ?? editingRecipe?.parent {
            Section {
                Label("Based on \(base.title)", systemImage: "arrow.triangle.branch")
                    .font(.subheadline).foregroundStyle(.secondary)
                TextField("What changed? e.g. Made it vegan", text: $draft.forkNote, axis: .vertical)
                    .lineLimit(1...4)
            } header: {
                Text("Fork")
            } footer: {
                Text("Shown on your variation so others know why it's different.")
            }
        }
    }

    private var detailsSection: some View {
        Section("Details") {
            TextField("Recipe title", text: $draft.title)
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                    Text("Cook time").lineLimit(1).fixedSize()
                }
                .foregroundStyle(.secondary)
                .accessibilityElement(children: .combine)
                TextField("Optional", text: $draft.cookTime)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                Text("min").foregroundStyle(.secondary)
            }
            if !CookTime.isValid(draft.cookTime) {
                Text("Enter a whole number from 1 to 1440.")
                    .font(.caption).foregroundStyle(Theme.red)
            }
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "person.2")
                    Text("Servings").lineLimit(1).fixedSize()
                }
                .foregroundStyle(.secondary)
                .accessibilityElement(children: .combine)
                TextField("Optional", text: $draft.servings)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            if !Servings.isValid(draft.servings) {
                Text("Enter a whole number from 1 to 99.")
                    .font(.caption).foregroundStyle(Theme.red)
            }
        }
    }

    private var ingredientsSection: some View {
        Section("Ingredients") {
            ForEach(draft.ingredients) { row in
                HStack {
                    TextField("Ingredient and quantity", text: rowBinding(row.id, in: \.ingredients), axis: .vertical)
                    if draft.ingredients.count > 1 {
                        Button(role: .destructive) {
                            guard draft.ingredients.count > 1 else { return }
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
    }

    private var methodSection: some View {
        Section("Method") {
            ForEach(Array(draft.steps.enumerated()), id: \.element.id) { index, row in
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("\(index + 1)").font(.subheadline.monospacedDigit()).foregroundStyle(.secondary)
                    TextField("Describe this step", text: rowBinding(row.id, in: \.steps), axis: .vertical)
                    if draft.steps.count > 1 {
                        Button(role: .destructive) {
                            guard draft.steps.count > 1 else { return }
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
    }

    private var tagsSection: some View {
        Section("Tags") { TagEditorView(tags: $draft.tags) }
    }

    private var navigationContent: some View {
        NavigationStack {
            layout
            .task(id: photoItem) {
                guard let item = photoItem,
                      let data = try? await item.loadTransferable(type: Data.self),
                      !Task.isCancelled else { return }
                draft.photoData = data
                draft.imageURL = nil
            }
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
