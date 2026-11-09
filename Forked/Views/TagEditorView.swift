import SwiftUI

struct TagEditorView: View {
    @Binding var tags: [String]
    @State private var newTag = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Text(tag)
                                Button {
                                    tags.removeAll { $0 == tag }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                            }
                            .buttonStyle(.borderless)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.red.opacity(0.1))
                            .foregroundStyle(Theme.red)
                            .clipShape(Capsule())
                        }
                    }
                }
            }

            HStack {
                TextField("Add a tag", text: $newTag)
                    .onSubmit(addTag)
                Button("Add", action: addTag)
                    .buttonStyle(.borderless)
                    .foregroundStyle(Theme.red)
                    .disabled(newTag.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private func addTag() {
        let trimmed = newTag.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(trimmed) else { return }
        tags.append(trimmed)
        newTag = ""
    }
}
