import Foundation
import CoreLocation

@MainActor
class WeatherService: ObservableObject {
    @Published var weatherResponse: WeatherResponse?
    private let openWeatherService = OpenWeatherService()
    private var timer: Timer?
    private var lastLocation: CLLocation?

    func startFetchingWeather(for location: CLLocation) {
        self.lastLocation = location
        // Fetch weather immediately
        Task {
            await fetchWeather(for: location)
        }

        // And then every 30 minutes
        timer = Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { [weak self] _ in
            guard let self = self, let location = self.lastLocation else { return }
            Task {
                await self.fetchWeather(for: location)
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
}
