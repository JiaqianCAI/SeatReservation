//  Bo's Part
//  SeatReservationApp.swift
//  SeatReservation
//
//  Created by Jiaqian Cai on 9/5/2025.
//

import SwiftUI
import SwiftData

@main
// Main entry point for the Seat Reservation app.
// This struct configures the SwiftData model and sets up the root ContentView.
struct SeatReservationApp: App {
        // Shared SwiftData model container, used to persist SeatReservationDB objects.
        var sharedModelContainer: ModelContainer = {
            // Define the schema for SwiftData (include SeatReservationDB model class)
            let schema = Schema([
                SeatReservationDB.self
            ])
            
            // Configure storage - here, using default local file system (not in-memory)
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            // Create and return the SwiftData container
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                // If the container fails to initialize, crash the app with a clear error
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
    
    //App body - start with ContentView and inject the model container
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer) // Make model available throughout the app
    }
}
