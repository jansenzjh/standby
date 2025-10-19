import SwiftUI

struct WeatherView: View {
    let weather: WeatherResponse?

    var body: some View {
        if let weather = weather {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // OpenWeatherMap icon URL: https://openweathermap.org/weather-conditions
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "").png")) {
                        $0.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)

                    Text("\(Int(weather.main.temp))°")
                        .font(.system(size: 40, weight: .bold))
                }

                Text(weather.weather.first?.description.capitalized ?? "")
                    .font(.body)

                HStack {
                    Text("H: \(Int(weather.main.temp_max))°")
                    Text("L: \(Int(weather.main.temp_min))°")
                }
                .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.black.opacity(0.25))
            )
        } else {
            ProgressView()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black.opacity(0.25))
                )
        }
    }
}