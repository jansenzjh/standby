
import Foundation
import Photos
import UIKit
import Combine

class LocalPhotosService: ObservableObject {
    @Published var isAuthorized = false
    @Published var photoCache: [UIImage] = []
    private var isFetching = false

    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.isAuthorized = (status == .authorized)
            }
        }
    }

    func getRandomPhotoFromCache() -> UIImage? {
        return photoCache.randomElement()
    }

    func fetchPhotoBatch() {
        guard isAuthorized, !isFetching else {
            return
        }

        isFetching = true
        var newPhotos: [UIImage] = []

        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        guard assets.count > 0 else {
            isFetching = false
            return
        }

        let group = DispatchGroup()
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true

        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)

        for _ in 0..<20 {
            let randomIndex = Int.random(in: 0..<assets.count)
            let asset = assets.object(at: randomIndex)

            group.enter()
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, info in
                if let image = image {
                    newPhotos.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.photoCache = newPhotos
            self.isFetching = false
        }
    }
}
