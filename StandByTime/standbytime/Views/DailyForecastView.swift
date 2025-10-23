
import SwiftUI

struct DailyForecastView: View {
    let forecasts: [DailyForecast]

    var body: some View {
        ZStack {
            // Semi-transparent black background
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text("4-Day Forecast")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)

                HStack(alignment: .top, spacing: 0) {
                    // We take the first 4 forecasts available.
                    ForEach(forecasts) { forecast in
                        VStack(spacing: 20) {
                            Text(day(from: forecast.date))
                                .font(.system(size: 30, weight: .bold))

                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(forecast.icon)@2x.png")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView().tint(.white)
                            }
                            .frame(width: 80, height: 80)

                            Text("H: \(Int(forecast.tempMax))°")
                                .font(.system(size: 24))
                            Text("L: \(Int(forecast.tempMin))°")
                                .font(.system(size: 24))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
    }

    private func day(from date: Date) -> String {
        let formatter = DateFormatter()
        // Check if it's today
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        // Otherwise, return the abbreviated day name (e.g., "Tue")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}