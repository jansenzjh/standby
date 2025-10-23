
import Foundation
import CoreLocation

// MARK: - OpenWeatherMap Data Models

struct WeatherResponse: Decodable {
    let weather: [WeatherInfo]
    let main: MainWeather
    let wind: Wind
    let name: String
}

struct ForecastResponse: Decodable {
    let list: [WeatherListItem]
}

struct WeatherListItem: Decodable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherInfo]
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
    private func apiKey() -> String {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = plist["APIKey"] as? String else {
            fatalError("API Key not found in Secrets.plist or is invalid.")
        }
        return key
    }

    private let baseURL = "https://api.openweathermap.org/data/2.5/"

    func fetchWeather(for location: CLLocation) async throws -> WeatherResponse {
        let urlString = "\(baseURL)weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey())&units=metric"
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
    
    func fetchForecast(for location: CLLocation) async throws -> [DailyForecast] {
        let urlString = "\(baseURL)forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey())&units=metric"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)

        // Group by day and calculate min/max temps
        let dailyData = Dictionary(grouping: forecastResponse.list) { (listItem) -> Date in
            let date = Date(timeIntervalSince1970: TimeInterval(listItem.dt))
            return Calendar.current.startOfDay(for: date)
        }

        var forecasts: [DailyForecast] = []
        let sortedKeys = dailyData.keys.sorted()
        for day in sortedKeys {
            if let dayData = dailyData[day], let firstItem = dayData.first {
                let minTemp = dayData.map { $0.main.temp_min }.min() ?? 0
                let maxTemp = dayData.map { $0.main.temp_max }.max() ?? 0
                let weatherIcon = firstItem.weather.first?.icon ?? ""
                let weatherDescription = firstItem.weather.first?.description ?? ""
                
                forecasts.append(DailyForecast(date: day, tempMin: minTemp, tempMax: maxTemp, icon: weatherIcon, weatherDescription: weatherDescription))
            }
        }
        
        return Array(forecasts.prefix(4))
    }
}
