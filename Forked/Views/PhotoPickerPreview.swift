import SwiftUI
import PhotosUI

struct PhotoPickerPreview: View {
    @Binding var photoItem: PhotosPickerItem?
    let photoData: Data?
    var imageURL: String? = nil
    var height: CGFloat = 260

    private var hasImage: Bool {
        photoData != nil || (imageURL?.isEmpty == false)
    }

    var body: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            ZStack {
                RecipePhotoView(photoData: photoData, imageURL: imageURL, height: height)
                if !hasImage {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 32))
                        Text("Add Photo")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
    }
}
