
import SwiftUI

struct LocalPhotoBackgroundView: View {
    let uiImage: UIImage?
    @State private var scale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            if let image = uiImage {
                let isPortrait = image.size.width < image.size.height
                
                if isPortrait {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .blur(radius: 20, opaque: true)
                            .clipped()

                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .scaleEffect(scale)
                            .clipped()
                    }
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .scaleEffect(scale)
                        .clipped()
                }
            } else {
                Color.black
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: startAnimation)
        .onChange(of: uiImage) { _ in
            startAnimation()
        }
    }

    private func startAnimation() {
        // Reset scale before starting animation
        self.scale = 1.0
        let duration = 15.0
        
        withAnimation(Animation.linear(duration: duration)) {
            scale = 1.2
        }
    }
}
