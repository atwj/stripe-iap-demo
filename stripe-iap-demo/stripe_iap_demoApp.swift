//
//  stripe_iap_demoApp.swift
//  stripe-iap-demo
//
//  Created by Amos Tan on 14/5/25.
//

import SwiftUI
import SwiftData
import Inject

@main
struct stripe_iap_demoApp: App {
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
            ContentView()
                .enableInjection()
        }
        .modelContainer(sharedModelContainer)
    }
}
