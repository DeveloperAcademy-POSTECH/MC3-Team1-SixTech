//
//  HistoryModel.swift
//  SixTech
//
//  Created by A_Mcflurry on 2023/07/27.
//

import CoreData

class CoredataManager: ObservableObject {
    let container = NSPersistentContainer(name: "history")
    
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Nooooooooooo? \(error.localizedDescription)")
            }
        }
    }
    
    func saveHistory(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Coredata save YEE")
        } catch {
            print("Failed to save data to CoreData: \(error.localizedDescription)")
        }
    }
    
    func addHistory(hist: History, context: NSManagedObjectContext) {
        let history = History(context: context)
        history.uuid = UUID()
        history.date = hist.date
        history.image = hist.image
        history.trash = hist.trash
        history.steps = hist.steps
        history.kilometer = hist.kilometer
        history.kcal = hist.kcal
        
        saveHistory(context: context)
    }
    
    func fetchHistory(targetDate: Date) -> [History] {
        let context: NSManagedObjectContext = CoredataManager().container.viewContext
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: targetDate) // 해당 날짜의 시작 시간
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)! // 해당 날짜의 다음 날 시작 시간
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let historyResults = try context.fetch(fetchRequest)
            return historyResults
        } catch {
            print("Error fetching history: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAllHistory() -> [History] {
        let context: NSManagedObjectContext = CoredataManager().container.viewContext
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        
        do {
            let historyResults = try context.fetch(fetchRequest)
            return historyResults
        } catch {
            print("Error fetching history: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteAllData() {
        let context: NSManagedObjectContext = CoredataManager().container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "History")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All data deleted successfully.")
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    func createDate(year: Int, month: Int, days: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = days
        
        let calendar = Calendar.current
        return calendar.date(from: components)!
    }
    
}
