import Foundation
import Combine
import GoogleSignIn
import UIKit

// NOTE: This service now contains the logic to handle Google Sign-In.
// You MUST complete Step 1 and Step 2 from the instructions for this to work.
// 1. Add the GoogleSignIn-iOS Swift Package.
// 2. Download your `GoogleService-Info.plist` file and add it to your project.
// 3. Add the REVERSED_CLIENT_ID from the .plist file to your project's URL Types.

class GooglePhotosService: ObservableObject {
    @Published var isSignedIn = false
    private var accessToken: String?

    init() {
        // Check if the user was previously signed in
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                self.accessToken = user.accessToken.tokenString
                self.isSignedIn = true
                print("Restored previous sign-in.")
            } else {
                print("No previous sign-in to restore.")
            }
        }
    }

    func signIn() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("Could not find root view controller.")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard error == nil, let result = result else {
                print("Sign-in error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.accessToken = result.user.accessToken.tokenString
            self.isSignedIn = true
            print("Signed in successfully.")
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.accessToken = nil
        self.isSignedIn = false
        print("Signed out.")
    }
    
    func search(category: String, completion: @escaping (URL?) -> Void) {
        guard isSignedIn, let accessToken = accessToken else {
            print("Not signed in. Cannot search for photos.")
            completion(nil)
            return
        }

        print("Searching for photos in category: \(category) with real access token.")

        // This is where you would make the real network request to the Google Photos API.
        // For now, it still returns a placeholder image.
        let randomImageUrl = URL(string: "https://picsum.photos/800/1200?random=\(Int.random(in: 1...1000))")
        completion(randomImageUrl)
    }
}
