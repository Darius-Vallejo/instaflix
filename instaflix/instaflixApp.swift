//
//  instaflixApp.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import SwiftUI

@main
struct instaflixApp: App {

    init() {
        _ = NetworkMonitor.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
