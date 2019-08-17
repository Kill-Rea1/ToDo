//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by Кирилл Иванов on 13/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoAppModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Loading to store failed:", error)
                return
            }
        }
        return container
    }()
    
    func saveChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            try context.save()
        } catch let saveError {
            print("Failed to save changes", saveError)
        }
    }
    
    func fetchCompanies() -> [List] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<List>(entityName: "List")
        do {
            let lists = try context.fetch(fetchRequest)
            return lists
        } catch let fetchError {
            print("Failed to fetch companies:", fetchError)
            return []
        }
    }
    
    func saveList(_ list: List, completion: @escaping (Error?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            try context.save()
            completion(nil)
        } catch let saveError {
            print("Failed to save list:", saveError)
            completion(saveError)
        }
    }
    
    func deleteList(_ list: List, completion: @escaping (Error?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(list)
        do {
            try context.save()
            completion(nil)
        } catch let deleteError {
            print("Failed to delete list:", deleteError)
            completion(deleteError)
        }
    }
    
    func saveTask(_ task: Task, completion: @escaping (Error?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            try context.save()
            completion(nil)
        } catch let saveError {
            print("Failed to save task:", saveError)
            completion(saveError)
        }
    }
    
    func deleteTask(_ task: Task, completion: @escaping (Error?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(task)
        do {
            try context.save()
            completion(nil)
        } catch let deleteError {
            print("Failed to delete task:", deleteError)
            completion(deleteError)
        }
    }
}
