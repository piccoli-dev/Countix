import SwiftUI
import UIKit

struct CountdownCardBackgroundLayer: View {
    let image: UIImage?
    let colors: [Color]

    init(image: UIImage?, colors: [Color]) {
        self.image = image
        self.colors = colors
    }

    init(
        fileName: String?,
        colors: [Color],
        resolveImage: (String) -> UIImage?
    ) {
        self.image = fileName.flatMap(resolveImage)
        self.colors = colors
    }

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }

            LinearGradient(
                colors: image != nil ? [colors[0], .clear] : colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
