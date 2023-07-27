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
    @StateObject private var coredataManager = CoredataManager()

    var body: some Scene {
        WindowGroup {
            CoredataTest()
                .environment(\.managedObjectContext, coredataManager.container.viewContext)
        }
    }
}
