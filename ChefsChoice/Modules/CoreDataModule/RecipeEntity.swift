//
//  RecipeEntity.swift
//  ChefsChoice
//
//  Created by Дмитрий on 01.03.2023.
//

import Foundation
import CoreData

public class RecipeEntity: NSManagedObject {
    
    class func allRecipesEntity(_ context: NSManagedObjectContext) throws -> [RecipeEntity] {
        
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "aggregateLikes", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
