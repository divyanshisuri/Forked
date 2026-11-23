// ShoppingItemRow.swift
// One checkable row on the shopping list.

import SwiftUI

struct ShoppingItemRow: View {
    @Bindable var item: ShoppingItem
    let onToggle: () -> Void

    var body: some View {
        Button {
            item.isChecked.toggle()
            onToggle()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isChecked ? Theme.red : Theme.secondaryText)
                Text(item.text)
                    .strikethrough(item.isChecked)
                    .foregroundStyle(item.isChecked ? Theme.secondaryText : Theme.text)
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: item.isChecked)
        .accessibilityAddTraits(item.isChecked ? .isSelected : [])
    }
}
