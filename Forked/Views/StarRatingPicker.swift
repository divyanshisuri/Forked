import SwiftUI

struct StarRatingPicker: View {
    @Binding var rating: Int
    var size: CGFloat = 28

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(Theme.red)
                    .onTapGesture { rating = star }
            }
        }
    }
}
