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

        do {
            return try makeModelContainer(schema: schema)
        } catch {
            fatalError("Unable to create persistent ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }

    private static func makeModelContainer(schema: Schema) throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        return try ModelContainer(for: schema, configurations: configuration)
    }
}
