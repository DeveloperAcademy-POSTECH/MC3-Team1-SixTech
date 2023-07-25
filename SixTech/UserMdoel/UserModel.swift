//
//  UserModel.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/25.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourDataModelName") // YourDataModelName에 데이터 모델의 이름을 넣어줍니다.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

class UserDataManager {
    static let shared = UserDataManager()
    
    func saveUser(nickName: String, profileURL: URL) {
        let context = CoreDataStack.shared.viewContext
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
            print("Failed to save user information: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() -> User? {
        let context = CoreDataStack.shared.viewContext
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
