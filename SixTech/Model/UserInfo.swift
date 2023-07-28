//
//  UserInfo.swift
//  SixTech
//
//  Created by 주환 on 2023/07/28.
//

import Foundation
import SwiftUI

class UserInfo: ObservableObject {
    @Published var name = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
    @Published var userHistory = UserHistory()
    
    func updateUserInfo() {
        self.name = UserDefaults.standard.string(forKey: "username") ?? ""
        self.profileImageURL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
        
        print("userinfo update = \(name), \(profileImageURL)!!")
    }
}

class UserHistory: ObservableObject {
    
    let date: Date? = nil
    let image: URL? = nil
    let trash: String? = nil
    let steps: String? = nil
    let kilometer: String? = nil
    let kcal: Int16? = nil
    
}
