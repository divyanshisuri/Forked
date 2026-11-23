// RecipePhotoPlaceholder.swift
// Shown while a photo loads or when a recipe has none.

import SwiftUI

struct RecipePhotoPlaceholder: View {
    var showsProgress = false
    var body: some View {
        ZStack {
            Theme.surface
            if showsProgress {
                ProgressView().tint(Theme.secondaryText)
            } else {
                Image(systemName: "fork.knife")
                    .font(.largeTitle.weight(.light))
                    .foregroundStyle(Theme.secondaryText.opacity(0.5))
            }
        }
    }
}
