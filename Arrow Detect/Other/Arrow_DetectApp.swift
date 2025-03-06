//
//  Arrow_DetectApp.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/10/2024.
//

import FirebaseCore
import SwiftUI
import SwiftData

@main
struct Arrow_DetectApp: App {
    
    @StateObject var authTest =  AuthenticationTest()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if authTest.isSignedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    init () {
        FirebaseApp.configure()
    }
}
