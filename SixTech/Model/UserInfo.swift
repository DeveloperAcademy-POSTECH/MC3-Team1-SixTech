//
//  UserInfo.swift
//  SixTech
//
//  Created by 주환 on 2023/07/28.
//

import Foundation
import SwiftUI

final class UserInfo: ObservableObject, Identifiable {
    @Published var uuid = UUID()
    @Published var name = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var profileImageURL: URL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
    @Published var profileImage: UIImage = UIImage()
    @Published var userHistory = UserHistory()
    
    func updateUserInfo() {
        self.name = UserDefaults.standard.string(forKey: "username") ?? ""
        self.profileImageURL = UserDefaults.standard.url(forKey: "profileURL") ?? URL(string: "onboarding2img")!
        
        print("userinfo update = \(name), \(profileImageURL)!!")
    }
}

final class UserHistory: ObservableObject {
    
    var date: Date?
    var image: URL?
    var trash: String?
    var steps: String?
    var kilometer: String?
    var kcal: Int16?
    
}

extension UserInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case profileImageURL
        case profileImage
        case userHistory
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(profileImageURL, forKey: .profileImageURL)
        if let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                   try container.encode(imageData, forKey: .profileImage)
               }
        try container.encode(userHistory, forKey: .userHistory)
    }

    convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        profileImageURL = try container.decode(URL.self, forKey: .profileImageURL)
        if let imageData = try container.decode(Data?.self, forKey: .profileImage) {
                    profileImage = UIImage(data: imageData) ?? UIImage()
                }
        userHistory = try container.decode(UserHistory.self, forKey: .userHistory)
    }
}

extension UserHistory: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case image
        case trash
        case steps
        case kilometer
        case kcal
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(image, forKey: .image)
        try container.encode(trash, forKey: .trash)
        try container.encode(steps, forKey: .steps)
        try container.encode(kilometer, forKey: .kilometer)
        try container.encode(kcal, forKey: .kcal)
    }

    convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date?.self, forKey: .date)
        image = try container.decode(URL?.self, forKey: .image)
        trash = try container.decode(String?.self, forKey: .trash)
        steps = try container.decode(String?.self, forKey: .steps)
        kilometer = try container.decode(String?.self, forKey: .kilometer)
        kcal = try container.decode(Int16?.self, forKey: .kcal)
    }
}

func encodeUserInfo(_ userInfo: UserInfo) -> Data? {
    let encoder = JSONEncoder()
    do {
        return try encoder.encode(userInfo)
    } catch {
        print("Error encoding UserInfo: \(error)")
        return nil
    }
}

func decodeUserInfo(_ data: Data) -> UserInfo? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(UserInfo.self, from: data)
    } catch {
        print("Error decoding UserInfo: \(error)")
        return nil
    }
}
