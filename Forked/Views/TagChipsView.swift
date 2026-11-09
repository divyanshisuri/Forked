import SwiftUI

struct TagChipsView: View {
    let tags: [String]
    @Binding var selected: Set<String>
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    let isSelected = selected.contains(tag)
                    Button {
                        if isSelected { selected.remove(tag) }
                        else { selected.insert(tag) }
                    } label: {
                        HStack(spacing: 5) {
                            if isSelected { Image(systemName: "checkmark") }
                            Text(tag)
                        }
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(isSelected ? Theme.red : Theme.cardBackground, in: Capsule())
                        .foregroundStyle(isSelected ? Theme.onAccent : Theme.secondaryText)
                        .overlay(Capsule().strokeBorder(isSelected ? Color.clear : Theme.separator, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .padding(.vertical, 2)
        }
    }
}
