//
//  frontendApp.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
//

import SwiftUI
import SwiftData

@main
struct frontendApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Patient.self,
            Doctor.self
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
            TabView {
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }

                ImageUploadView()
                    .tabItem {
                        Label("Upload", systemImage: "photo")
                    }

                DoctorListView()
                    .tabItem {
                        Label("Doctors", systemImage: "stethoscope")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
