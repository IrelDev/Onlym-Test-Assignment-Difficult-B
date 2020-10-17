//
//  CoreDataService.swift
//  OnlimTestTaskDifficultB
//
//  Created by Kirill Pustovalov on 17.10.2020.
//

import UIKit
import CoreData

struct CoreDataService {
    public func fetchHomeModelData() -> NSData? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HomeModelEntity")
        
        do {
            let fetchRequestResults = try managedContext.fetch(fetchRequest)
            
            let data = fetchRequestResults.first?.value(forKey: "data") as? NSData
            return data
            
        } catch {
            print("could not fetch data \(error.localizedDescription)")
        }
        return nil
    }
    public func saveHomeModelData(data: NSData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HomeModelEntity", in: managedContext)!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HomeModelEntity")
        
        do {
            let fetchRequestResults = try managedContext.fetch(fetchRequest)
            if fetchRequestResults.count == 0 {
                let nsmanagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
                
                nsmanagedObject.setValue(data, forKeyPath: "data")
            } else {
                let previousResults = fetchRequestResults.first!
                
                previousResults.setValue(data, forKey: "data")
            }
            try managedContext.save()
        } catch {
            print("Error, could not save data \(error.localizedDescription)")
        }
    }
}


