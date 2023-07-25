//
//  SixTechApp.swift
//  SixTech
//
//  Created by 이재원 on 2023/07/09.
//

import SwiftUI

@main
struct SixTechApp: App {
    @StateObject var matchManager = MatchManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(matchManager)
        }
    }
}
