//
//  RecipeEntity.swift
//  ChefsChoice
//
//  Created by Дмитрий on 01.03.2023.
//

import Foundation
import CoreData

class RecipeEntity: NSManagedObject {
    
    class func findOrCreate(_ recipeModel: RecipeModel, context: NSManagedObjectContext) throws -> RecipeEntity {
        
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", recipeModel.id)
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult .count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB!")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        let recipeEntity = RecipeEntity(context: context)
//        recipeEntity.id = recipeModel.id
//        recipeEntity.title = recipeModel.title
//        recipeEntity.aggregateLikes = Int64(recipeModel.aggregateLikes ?? 0)
//        recipeEntity.readyInMinutes = Int64(recipeModel.readyInMinutes ?? 0)
        //recipeEntity.image = recipesModel.image
        
        return recipeEntity
    }
    
    class func allRecipesEntity(_ context: NSManagedObjectContext) throws -> [RecipeEntity] {
        
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
