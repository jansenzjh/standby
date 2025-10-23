import Foundation
import CoreLocation

@MainActor
class WeatherService: ObservableObject {
    @Published var weatherResponse: WeatherResponse?
    @Published var dailyForecasts: [DailyForecast] = []
    private let openWeatherService = OpenWeatherService()
    private var timer: Timer?
    private var lastLocation: CLLocation?

    func startFetchingWeather(for location: CLLocation) {
        self.lastLocation = location
        // Fetch weather immediately
        Task {
            await fetchWeather(for: location)
            await fetchForecast(for: location)
        }

        // And then every 30 minutes
        timer = Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { [weak self] _ in
            guard let self = self, let location = self.lastLocation else { return }
            Task {
                await self.fetchWeather(for: location)
                await self.fetchForecast(for: location)
            }
        }
    }

    func stopFetchingWeather() {
        timer?.invalidate()
        timer = nil
    }

    func fetchWeather(for location: CLLocation) async {
        do {
            let weatherResponse = try await openWeatherService.fetchWeather(for: location)
            self.weatherResponse = weatherResponse
        } catch {
            print("Failed to fetch weather: \(error.localizedDescription)")
        }
    }
    
    func fetchForecast(for location: CLLocation) async {
        do {
            let forecasts = try await openWeatherService.fetchForecast(for: location)
            self.dailyForecasts = forecasts
        } catch {
            print("Failed to fetch forecast: \(error.localizedDescription)")
        }
    }
}
