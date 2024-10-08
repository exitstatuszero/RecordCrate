//
//  RecordCrateApp.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import SwiftUI
import SwiftData

@main
struct RecordCrateApp: App {
    
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
    
    ///
    static let musicKitMonitor: MusicKitMonitor = MusicKitMonitor.shared
    
    ///
    static let networkMonitor: NetworkMonitor = NetworkMonitor.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)        
    }
}
