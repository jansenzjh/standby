//
//  ContentView.swift
//  standbytime
//
//  Created by Semih Kesgin on 21.07.2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentTime = Date()

    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
        VStack {
            Text(getFormattedTime())
                .tracking(-1)
                .font(.custom(
                                    "SquadaOne-Regular",
                                    fixedSize: 180
                                    ))
                .foregroundColor(Color("Green"))
               /* .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .purple, .red],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        
                                    )
                */
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(colorScheme == .dark ? Color.customDarkModeColor : Color.customLightModeColor)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .onAppear {
            // Update the time using the timer
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentTime = Date()
            }
            // Run loop to make the timer work
            RunLoop.current.add(timer, forMode: .common)
        }
        }
    }

    // Helper function to get the time in HH:mm format
    func getFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentTime)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
