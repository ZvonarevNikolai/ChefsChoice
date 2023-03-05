//
//  RecipesData.swift
//  ChefsChoice
//
//  Created by Андрей Фроленков on 28.02.23.
//

import Foundation

struct RecipesData: Codable {
    
    let results: [RecipeData]
    
}

struct RecipeData: Codable {
    
    let id: Int
    let title: String
    let image: String
    let preparationMinutes: Int
    let readyInMinutes: Int
    let veryHealthy: Bool
    let aggregateLikes: Int
    let servings: Int
    let summary: String
    let analyzedInstructions: [AnalyzedInstructions]
    
}

struct AnalyzedInstructions: Codable {
    
    let steps: [Steps]
      
}

struct Steps: Codable {
    
    let number: Int
    let step: String
    let ingredients: [Ingredients]
    
}

struct Ingredients: Codable {
    
    let name: String
}




