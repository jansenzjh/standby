
import Foundation

struct DailyForecast: Identifiable {
    let id = UUID()
    let date: Date
    let tempMin: Double
    let tempMax: Double
    let icon: String
    let weatherDescription: String
}
