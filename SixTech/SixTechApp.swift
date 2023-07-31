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
    @StateObject private var matchManager = MatchManager.shared
    @StateObject private var historyManager = CoredataManager()
    @StateObject private var userInfo = UserInfo()
	@StateObject var ploggingManager = PloggingManager()
	@StateObject var mapManager = MapManager.shared

    @AppStorage("onboarding") private var isOnboardingActive: Bool = true
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isOnboardingActive {
                    OnBoardingView()
                } else {
                    MainView()
                }
            }
            .environmentObject(matchManager).environmentObject(userInfo)
			.environmentObject(ploggingManager).environmentObject(mapManager)
            .environment(\.managedObjectContext, historyManager.container.viewContext)
        }

    }
}
