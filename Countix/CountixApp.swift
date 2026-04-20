//
//  CountixApp.swift
//  Countix
//
//  Created by Francesca Piccoli on 20/04/2026.
//

import SwiftData
import SwiftUI

@main
struct CountixApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Event.self
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Unable to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
