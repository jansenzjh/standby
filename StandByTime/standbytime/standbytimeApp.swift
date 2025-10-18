//
//  standbytimeApp.swift
//  standbytime
//
//  Created by Semih Kesgin on 21.07.2023.
//

import SwiftUI
import GoogleSignIn

@main
struct standbytimeApp: App {
    var body: some Scene {
        WindowGroup {
            ThirdPage()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
