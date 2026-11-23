// SectionHeader.swift
// Consistent heading style for sections on recipe pages.

import SwiftUI

struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title).font(.title3.weight(.semibold)).foregroundStyle(Theme.text)
    }
}
