//
//  HealthKitTestsApp.swift
//  HealthKitTests
//
//  Created by Justin Lai on 2024/8/20.
//

import SwiftUI

@main
struct HealthKitTestsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
