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
    @StateObject var matchManager = MatchManager()
    
    var body: some Scene {
        WindowGroup {
            ShareImgeView(images: [])
            .frame(height: 200)
                .environmentObject(matchManager)
        }
    }
}
