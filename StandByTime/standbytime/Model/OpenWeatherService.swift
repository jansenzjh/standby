
import Foundation
import CoreLocation

// MARK: - OpenWeatherMap Data Models

struct WeatherResponse: Decodable {
    let weather: [WeatherInfo]
    let main: MainWeather
    let wind: Wind
    let name: String
}

struct WeatherInfo: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}

// MARK: - OpenWeatherService

class OpenWeatherService {
    private let apiKey = "YOUR_API_KEY" // TODO: Replace with your OpenWeatherMap API key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for location: CLLocation) async throws -> WeatherResponse {
        let urlString = "\(baseURL)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
           print(JSONString)
        }
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weatherResponse
    }
}
