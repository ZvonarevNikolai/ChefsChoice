//
//  APIManager.swift
//  ChefsChoice
//
//  Created by Андрей Фроленков on 3.03.23.
//

import Foundation
import UIKit

enum SortRecipe: String {
    
    case popularity
    case random
    case time
    
}

enum CategoryRecipe: String {
    
    case mainСourse = "main_course"
    case dessert = "dessert"
    case salad = "salad"
    case breakfast = "breakfast"
    case soup = "soup"
    case drink = "drink"
    
    var title: String {
        switch self {
        case .mainСourse:
            return "Main Course"
        case .dessert:
            return "Desserts"
        case .salad:
            return "Salads"
        case .breakfast:
            return "Breakfast"
        case .soup:
            return "Soups"
        case .drink:
            return "Drinks"
        }
    }
}

enum Diet: String {
    case vegan = "vegan|vegetarian"
    case keto = "ketogenic"
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


    let apiKey = "e95f9d8a3706438892ed10eb377ef4e4"

    
    let categories: [RecipeModel] = [
        .init(id: 4, title: "Main Course", image: "maincourse",
              preparationMinutes: 0, readyInMinutes: 0, veryHealthy: false,
              aggregateLikes: 0, servings: 0, analyzedInstructions: nil,
              summary: nil, photo: nil),
        .init(id: 1, title: "Soup", image: "hot-soup", preparationMinutes: 0,
              readyInMinutes: 0, veryHealthy: false, aggregateLikes: 0,
              servings: 0, analyzedInstructions: nil, summary: nil, photo: nil),
        .init(id: 3, title: "Breakfast", image: "breakfast", preparationMinutes: 0,
              readyInMinutes: 0, veryHealthy: true, aggregateLikes: 0,
              servings: 0, analyzedInstructions: nil, summary: nil, photo: nil),
        .init(id: 2, title: "Salad", image: "salad", preparationMinutes: 0,
              readyInMinutes: 0, veryHealthy: true, aggregateLikes: 0,
              servings: 0, analyzedInstructions: nil, summary: nil, photo: nil),
        .init(id: 0, title: "Dessert", image: "cupcake", preparationMinutes: 0,
              readyInMinutes: 0, veryHealthy: false, aggregateLikes: 0,
              servings: 0, analyzedInstructions: nil, summary: nil, photo: nil),
        .init(id: 5, title: "Drink", image: "drink", preparationMinutes: 0,
              readyInMinutes: 0, veryHealthy: false, aggregateLikes: 0,
              servings: 0, analyzedInstructions: nil, summary: nil, photo: nil)
    ]
    
    func fetchRecipe(sort: SortRecipe, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        
        let urlString = "\(recipeURL)?apiKey=\(apiKey)&sort=\(sort.rawValue)&addRecipeInformation=true"
        request(with: urlString) { recipeModel in
            switch recipeModel {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecipe(word: String, sort: SortRecipe, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        let urlString = "\(recipeURL)?apiKey=\(apiKey)&query=\(word)&sort=\(sort.rawValue)&addRecipeInformation=true"
        request(with: urlString) { recipeModel in
            switch recipeModel {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecipeFilter(category: CategoryRecipe, sort: SortRecipe, number: Int, maxReadyTime: Int, diet: Diet?, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
      
        var urlString = ""
        if diet != nil {
            
            urlString = "\(recipeURL)?apiKey=\(apiKey)&type=\(category.rawValue)&diet=\(diet!.rawValue)&addRecipeInformation=true&sort=\(sort.rawValue)&maxReadyTime=\(maxReadyTime)&number=\(number)"
            
        } else {
            urlString = "\(recipeURL)?apiKey=\(apiKey)&type=\(category.rawValue)&addRecipeInformation=true&sort=\(sort.rawValue)&maxReadyTime=\(maxReadyTime)&number=\(number)"
            
        }
        
        request(with: urlString) { recipeModel in
            switch recipeModel {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchRecipe(category: CategoryRecipe, sort: SortRecipe, number: Int, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        let urlString = "\(recipeURL)?apiKey=\(apiKey)&type=\(category.rawValue)&addRecipeInformation=true&sort=\(sort.rawValue)&number=\(number)"
        request(with: urlString) { recipeModel in
            switch recipeModel {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request(with urlString: String, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                self.parseJSON(data) { recipe in
                    switch recipe {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Ingredient
    
    func fetchIngredient(with id: Int, completion: @escaping ([Ingredient]) -> Void) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/ingredientWidget.json?apiKey=\(apiKey)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(IngredientData.self, from: data)
                completion(decodedData.ingredients)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func parseJSON(_ recipes: Data, completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RecipesData.self, from: recipes)
            
            var result = [RecipeModel]()

            for object in decodedData.results {
                let recipe = RecipeModel(
                    id: object.id, title: object.title, image: object.image,
                    preparationMinutes: object.preparationMinutes,
                    readyInMinutes: object.readyInMinutes,
                    veryHealthy: object.veryHealthy,
                    aggregateLikes: object.aggregateLikes,
                    servings: object.servings,
                    analyzedInstructions: object.analyzedInstructions,
                    summary: object.summary, photo: nil
                )
                result.append(recipe)
            }
            let recipe = Recipes(results: result)
            completion(.success(recipe.getRecipes()))
        } catch {
            print("Error \(error.localizedDescription) ")
            completion(.failure(error))
        }
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
}
