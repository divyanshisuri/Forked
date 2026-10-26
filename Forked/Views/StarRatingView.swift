import SwiftUI

struct StarRatingView: View {
    let rating: Int
    var maximum: Int = 5
    var size: CGFloat = 16

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maximum, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(Theme.red)
            }
        }
    }
}
