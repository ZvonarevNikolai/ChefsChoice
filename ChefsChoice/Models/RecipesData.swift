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
    let cookingMinutes: Int
    let veryHealthy: Bool
    let aggregateLikes: Int
}
