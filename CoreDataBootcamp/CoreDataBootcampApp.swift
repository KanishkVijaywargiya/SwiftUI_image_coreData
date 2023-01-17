//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by Kanishk Vijaywargiya on 14/01/23.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ApiManager(context: persistenceController.container.viewContext))
        }
    }
}
