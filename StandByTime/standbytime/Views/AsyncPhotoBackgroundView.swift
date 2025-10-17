import SwiftUI

struct AsyncPhotoBackgroundView: View {
    let imageUrl: URL
    @State private var scale: CGFloat = 1.0
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(scale)
                    .offset(x: xOffset, y: yOffset)
                    .clipped()
                    .onAppear {
                        startAnimation()
                    }
            } placeholder: {
                Color.black
            }
        }
        .ignoresSafeArea()
    }

    private func startAnimation() {
        let duration = Double.random(in: 15...25)
        
        withAnimation(Animation.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            scale = 1.5
            xOffset = CGFloat.random(in: -80...80)
            yOffset = CGFloat.random(in: -80...80)
        }
    }
}
