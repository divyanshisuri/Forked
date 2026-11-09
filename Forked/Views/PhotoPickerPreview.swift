import SwiftUI
import PhotosUI

struct PhotoPickerPreview: View {
    @Binding var photoItem: PhotosPickerItem?
    let photoData: Data?
    var imageURL: String? = nil
    var height: CGFloat = 260

    private var hasImage: Bool { photoData != nil || imageURL?.isEmpty == false }

    var body: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            ZStack {
                if hasImage {
                    RecipePhotoView(photoData: photoData, imageURL: imageURL, height: height)
                        .overlay(alignment: .bottomTrailing) {
                            Label("Change photo", systemImage: "camera")
                                .font(.caption.weight(.semibold))
                                .padding(10)
                                .background(.regularMaterial, in: Capsule())
                                .padding(12)
                        }
                } else {
                    Theme.surface
                    VStack(spacing: 10) {
                        Image(systemName: "camera").font(.title)
                        Text("Add a photo").font(.subheadline.weight(.medium))
                        Text("Give your recipe a little personality.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: height)
            .foregroundStyle(Theme.secondaryText)
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
    }
}
