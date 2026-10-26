import SwiftUI

struct RecipePhotoView: View {
    let photoData: Data?
    var imageURL: String? = nil
    var height: CGFloat = 200

    var body: some View {
        Group {
            if let photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty:
                        RecipePhotoPlaceholder(showsProgress: true)
                    case .failure:
                        RecipePhotoPlaceholder()
                    @unknown default:
                        RecipePhotoPlaceholder()
                    }
                }
            } else {
                RecipePhotoPlaceholder()
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}
