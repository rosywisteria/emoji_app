//
//  genaiApp.swift
//  genai
//
//  Created by emily on 9/15/25.
//

import SwiftUI
import SwiftData

@main
struct genaiApp: App {
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
            EmojiGuessGameView()
        }
        .modelContainer(sharedModelContainer)
    }
}
