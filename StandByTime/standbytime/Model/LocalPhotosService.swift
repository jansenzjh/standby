
import Foundation
import Photos
import UIKit

class LocalPhotosService: ObservableObject {
    @Published var isAuthorized = false

    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.isAuthorized = (status == .authorized)
            }
        }
    }

    func search(category: String, completion: @escaping (UIImage?) -> Void) {
        guard isAuthorized else {
            print("Not authorized to access photo library.")
            requestAuthorization()
            completion(nil)
            return
        }

        let assets = PHAsset.fetchAssets(with: .image, options: nil)

        guard assets.count > 0 else {
            print("No photos found.")
            completion(nil)
            return
        }

        let randomIndex = Int.random(in: 0..<assets.count)
        let asset = assets.object(at: randomIndex)

        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { image, info in
            if let error = info?[PHImageErrorKey] as? Error {
                print("Error requesting image: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(image)
            }
        }
    }
}
