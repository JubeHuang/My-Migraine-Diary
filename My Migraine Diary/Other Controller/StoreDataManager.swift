//
//  StoredDataManager.swift
//  My Migraine Diary
//
//  Created by Jube on 2023/5/18.
//

import CoreData
import UIKit

class StoreDataManager {
    
    static let shared = StoreDataManager()
    
    var container: NSPersistentContainer {
        didSet {
            records = container.getRecordsTimeAsc()
        }
    }
    var records: [Record]
    var latestRecord: Record? { records.first }
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        records = container.getRecordsTimeAsc()
    }
}

extension NSPersistentContainer {
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                StoreDataManager.shared.container  = appDelegate.persistentContainer
                print("save extension")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getRecordsTimeAsc() -> [Record] {
        var records = [Record]()
        let request = Record.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Record.startTime, ascending: false)
        ]
        
        do {
            records = try viewContext.fetch(request)
            
            let stillGoingRecords = records.filter({ $0.stillGoing == true })
            
            records = records.filter({ !$0.stillGoing })
            records.insert(contentsOf: stillGoingRecords, at: 0)
        } catch {
            print("fetch faild")
        }
        return records
    }
}
