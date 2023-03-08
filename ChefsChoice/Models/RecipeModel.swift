//
//  RecipeModel.swift
//  ChefsChoice
//
//  Created by Андрей Фроленков on 28.02.23.
//

import Foundation
import UIKit

struct Recipes {
    
    private let results: [RecipeModel]
    
    init(results: [RecipeModel]) {
        self.results = results
    }
    
    func getRecipes() -> [RecipeModel] {
        
        return results
    }
    
}

struct RecipeModel {
    let id: Int
    let title: String
    let image: String?
    let preparationMinutes: Int?
    let readyInMinutes: Int?
    let veryHealthy: Bool?
    let aggregateLikes: Int?
    let servings: Int?
    let analyzedInstructions: [AnalyzedInstructions]?
    let summary: String?
    
    let photo: Data?
}


