//
//  DataController.swift
//  RecipeBook
//
//  Created by Mikhail on 11/29/20.
//

import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "RecipeBook")
    }
    
    func load() {
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    static let shared = DataController()
}
