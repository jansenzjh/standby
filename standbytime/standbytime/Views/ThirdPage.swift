//
//  ThirdPage.swift
//  standbytime
//
//  Created by Semih Kesgin on 27.07.2023.
//

import SwiftUI
import CoreLocation

struct ThirdPage: View {

    @Environment(\.colorScheme) var colorScheme
    let date = Date()
    @State private var isBouncing = false
    @State private var currentTime = Date()
    @State private var backgroundImage: UIImage?
    @State private var showingSettings = false
    @State private var showingForecast = false
    @StateObject private var localPhotosService = LocalPhotosService()
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationService = LocationService()

    var body: some View {
        ZStack {
            if showingForecast {
                DailyForecastView(forecasts: weatherService.dailyForecasts)
            } else {
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
                    
                    // Bottom content
                    HStack {
                        if let weather = weatherService.weatherResponse {
                            WeatherView(weather: weather)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                                .padding()
                        } else {
                            ProgressView().tint(.white)
                                .padding()
                        }
                        Spacer()
                    }
                }
            }
        }
        // A tap gesture to show settings
        .onTapGesture {
            showingSettings.toggle()
        }
        .onAppear {
            localPhotosService.requestAuthorization()
            localPhotosService.fetchPhotoBatch()
            locationService.requestLocation()
            setupTimers()
        }
        .onReceive(localPhotosService.$photoCache) { newCache in
            if !newCache.isEmpty {
                self.updateBackgroundImage()
            }
        }
        .onChange(of: locationService.location) { newLocation in
            if let location = newLocation {
                weatherService.startFetchingWeather(for: location)
            }
        }
        .onDisappear {
            weatherService.stopFetchingWeather()
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
        let batchTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { _ in
            localPhotosService.fetchPhotoBatch()
        }
        RunLoop.current.add(batchTimer, forMode: .common)

        // Timer for full-screen photo
        let forecastTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            showForecast()
        }
        RunLoop.current.add(forecastTimer, forMode: .common)
    }
    
    private func showForecast() {
        if !weatherService.dailyForecasts.isEmpty {
            showingForecast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                showingForecast = false
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
