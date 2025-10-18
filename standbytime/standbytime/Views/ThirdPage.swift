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
    @State private var backgroundImage: UIImage?
    @State private var showingSettings = false
    @StateObject private var localPhotosService = LocalPhotosService()
    @State private var showingFullScreenPhoto = false
    @State private var fullScreenImage: UIImage?

    var body: some View {
        ZStack {
            if let image = backgroundImage {
                LocalPhotoBackgroundView(uiImage: image)
            } else {
                Color.black
                    .ignoresSafeArea()
            }

            // UI Elements
            VStack {
                // Top-right content
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(getFormattedTime())
                            .font(.custom("SquadaOne-Regular", size: 120))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 5, x: 2, y: 2)

                        HStack(spacing: 10) {
                            Text(date.formatted(.dateTime.weekday()))
                            Text(date.formatted(.dateTime.day()))
                        }
                        .font(.custom("SquadaOne-Regular", size: 40))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Bottom-right content
                HStack {
                    Spacer()
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            
            if showingFullScreenPhoto, let image = fullScreenImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            localPhotosService.requestAuthorization()
            localPhotosService.fetchPhotoBatch()
            setupTimers()
        }
        .onReceive(localPhotosService.$photoCache) { newCache in
            if !newCache.isEmpty {
                self.updateBackgroundImage()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(localPhotosService)
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
            updateBackgroundImage()
        }
        RunLoop.current.add(photoTimer, forMode: .common)
        
        // Timer to fetch new batch of photos
        let batchTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            localPhotosService.fetchPhotoBatch()
        }
        RunLoop.current.add(batchTimer, forMode: .common)

        // Timer for full-screen photo
        let fullScreenPhotoTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            showFullScreenPhoto()
        }
        RunLoop.current.add(fullScreenPhotoTimer, forMode: .common)
    }
    
    private func showFullScreenPhoto() {
        fullScreenImage = localPhotosService.getRandomPhotoFromCache()
        if fullScreenImage != nil {
            showingFullScreenPhoto = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                showingFullScreenPhoto = false
            }
        }
    }
    
    private func updateBackgroundImage() {
        self.backgroundImage = localPhotosService.getRandomPhotoFromCache()
    }
}

struct ThirdPage_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPage()
    }
}
