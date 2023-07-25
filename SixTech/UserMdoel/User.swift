//
//  User.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/25.
//

import Foundation
import CoreData

extension User {
    // 함수에서 NSManagedObjectContext를 사용할 수 있도록 추가합니다.
    static func createOrUpdateUser(nickName: String, profileURL: URL, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            if let existingUser = users.first {
                // 이미 유저 정보가 있는 경우 업데이트
                existingUser.nickName = nickName
                existingUser.profileURL = profileURL
            } else {
                // 유저 정보가 없는 경우 새로 생성
                let newUser = User(context: context)
                newUser.nickName = nickName
                newUser.profileURL = profileURL
            }
            try context.save()
            print("User information saved successfully.")
        } catch {
            print("Failed to create/update user information: \(error.localizedDescription)")
        }
    }

    static func fetchUser(in context: NSManagedObjectContext) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user information: \(error.localizedDescription)")
            return nil
        }
    }
}
