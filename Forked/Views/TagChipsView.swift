import SwiftUI

struct TagChipsView: View {
    let tags: [String]
    @Binding var selected: Set<String>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    let isSelected = selected.contains(tag)
                    Text(tag)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(isSelected ? Theme.red : Color.white)
                        .foregroundStyle(isSelected ? Color.white : Theme.red)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Theme.red, lineWidth: isSelected ? 0 : 1.5)
                        )
                        .onTapGesture {
                            if isSelected {
                                selected.remove(tag)
                            } else {
                                selected.insert(tag)
                            }
                        }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}
