//
//  SixTechApp.swift
//  SixTech
//
//  Created by 이재원 on 2023/07/09.
//

import SwiftUI
import CoreData

@main
struct SixTechApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
