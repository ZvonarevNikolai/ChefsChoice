//
//  RecipesManager.swift
//  ChefsChoice
//
//  Created by Андрей Фроленков on 28.02.23.
//

import Foundation
import UIKit

protocol RecipeManagerDelegate {
    
    func didUpdateRecipes(_ recipeManager: RecipesManager, recipes: [RecipeModel])
    func didFailWithError(error: Error)
}

enum SortRecipe: String {
    
    case popularity
    case random
}

enum CategoryRecipe: String {
    
    case pasta
    case soup
    case salad
    case seafood
    case steak
    case dessert
}

enum SizeImage: String {
    
    case size90x90 = "90x90"
    case size240x150 = "240x150"
    case size312x150 = "312x150"
    case size480x360 = "480x360"
    case size556x370 = "556x370"
    case size636x393 = "636x393"
    
}

struct RecipesManager {
    
    let recipeURL = "https://api.spoonacular.com/recipes/complexSearch"
    let apiKey = "2b797d8c672342758091323d1c938349"
    
    var delegate: RecipeManagerDelegate?
    
    func fetchRecipe(sort: SortRecipe) {
        
        let urlString = "\(recipeURL)?apiKey=\(apiKey)&sort=\(sort.rawValue)"
        performRequest(with: urlString)
    }
    
    func fetchImage(id recipe: Int, size: SizeImage, completionHandler: @escaping (UIImage)->Void) {
        
        let urlString = "https://spoonacular.com/recipeImages/\(recipe)-\(size.rawValue).jpg"
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            completionHandler(image)
                        }
                    }
                }
                
            }.resume()
            
        }
    }
    
    func fetchRecipe(category: CategoryRecipe, sort: SortRecipe, number: Int) {
        let urlString = "\(recipeURL)?apiKey=\(apiKey)&query=\(category.rawValue)&addRecipeInformation=true&sort=\(sort.rawValue)&number=\(number)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                
                if let data = data {
                    if let recipe = self.parseJSON(data) {
                        print(recipe)
                        self.delegate?.didUpdateRecipes(self, recipes: recipe)
                    }
                }
            }
            
            task.resume()
        }
    }
    
        func parseJSON(_ recipes: Data) -> [RecipeModel]? {
    
            let decoder = JSONDecoder()
    
            do {
                let decodedData = try decoder.decode(RecipesData.self, from: recipes)
                
                var result = [RecipeModel]()
                
                for object in decodedData.results {
                    let recipe = RecipeModel(id: object.id,
                                             title: object.title,
                                             image: object.image,
                                             preparationMinutes: object.preparationMinutes,
                                             cookingMinutes: object.cookingMinutes,
                                             veryHealthy: object.veryHealthy,
                                             aggregateLikes: object.aggregateLikes
                    )
                    
                    result.append(recipe)
                }
                
                let recipe = Recipes(results: result)
                return recipe.getRecipes()
                
            } catch {
                self.delegate?.didFailWithError(error: error)
                return nil
            }
        }
    
}
