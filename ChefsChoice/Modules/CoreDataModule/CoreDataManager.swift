//
//  CoreDataManager.swift
//  ChefsChoice
//
//  Created by Дмитрий on 04.03.2023.
//

import Foundation
import CoreData

/*

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var context = persistentContainer.viewContext
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChefsChoice")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getAllRecipes(_ complitionHandler: @escaping ([RecipeModel]) -> Void) {
        
        context.perform {
            let recipeEntities = try? RecipeEntity.allRecipesEntity(self.context)
            
            let dBRecipes = recipeEntities?.map({RecipeModel(
                id: Int($0.id),
                title: $0.title,
                image: nil,
                preparationMinutes: nil,
                readyInMinutes: Int($0.readyInMinutes),
                veryHealthy: nil,
                aggregateLikes: Int($0.aggregateLikes),
                servings: nil,
                summary: nil,
                analyzedInstructions: nil)})
            
            complitionHandler(dBRecipes ?? [])
        }
    }
    
    func save(recipes: [RecipeModel]) {
        context.perform {
            for recipe in recipes {
                _ = try? RecipeEntity.findOrCreate(recipe, context: self.context)
            }
            try? self.context.save()
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

*/
