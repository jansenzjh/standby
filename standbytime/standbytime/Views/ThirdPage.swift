//
//  ThirdPage.swift
//  standbytime
//
//  Created by Semih Kesgin on 27.07.2023.
//

import SwiftUI

struct ThirdPage: View {

    @Environment(\.colorScheme) var colorScheme
    let date = Date()
    @State private var isBouncing = false
    @State private var currentTime = Date()
    @State private var backgroundImageUrl: URL?
    @State private var showingSettings = false
    @StateObject private var googlePhotosService = GooglePhotosService()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let url = backgroundImageUrl {
                AsyncPhotoBackgroundView(imageUrl: url)
            } else {
                Color.black
                    .ignoresSafeArea()
            }
            
            Button(action: {
                showingSettings.toggle()
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            
            ZStack {
                // time display
                Text(getFormattedTime())
                    .foregroundColor(Color("Green"))
                    .padding(.leading, -130)
                    .font(.custom(
                        "SquadaOne-Regular",
                        fixedSize: 250
                    ))
                    .scaleEffect(isBouncing ? 1.1 : 1.0)
                
                
                // day display
                Text(date.formatted(.dateTime.weekday()))
                    .foregroundColor(Color("Green"))
                    .font(.title)
                    .padding(.top, -90)
                    .padding(.leading, 450)
                    .font(.custom(
                        "SquadaOne-Regular",
                        fixedSize: 250
                    ))
                
                // day as number
                Text(date.formatted(.dateTime.day()))
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.top, -90)
                    .padding(.leading, 550)
                    .font(.custom(
                        "SquadaOne-Regular",
                        fixedSize: 250
                    ))
            }
            .onAppear {
                setupTimers()
                if googlePhotosService.isSignedIn {
                    fetchRandomPhoto()
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(googlePhotosService)
            }
        }
    }

    // Helper function to get the time in HH:mm format
    func getFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentTime)
    }
    
    private func setupTimers() {
        // Update the time using the timer
        let clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date()
        }
        RunLoop.current.add(clockTimer, forMode: .common)
        
        // Timer to shuffle background photo
        let photoTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            if googlePhotosService.isSignedIn {
                fetchRandomPhoto()
            }
        }
        RunLoop.current.add(photoTimer, forMode: .common)
    }
    
    private func fetchRandomPhoto() {
        let category = UserDefaults.standard.string(forKey: "selectedGooglePhotosCategory") ?? "Nature"
        googlePhotosService.search(category: category) { url in
            DispatchQueue.main.async {
                self.backgroundImageUrl = url
            }
        }
    }
}

struct ThirdPage_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPage()
    }
}
