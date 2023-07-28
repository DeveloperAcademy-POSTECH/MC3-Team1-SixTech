//
//  UserInfo.swift
//  SixTech
//
//  Created by 주환 on 2023/07/28.
//

import Foundation

class UserInfo: ObservableObject {
    @Published var name = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
    
    func updateUserInfo() {
        self.name = UserDefaults.standard.string(forKey: "username") ?? ""
        self.profileImageURL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
        
        print("userinfo update = \(name), \(profileImageURL)!!")
    }
}
