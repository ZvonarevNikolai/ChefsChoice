//
//  SectionList.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import Foundation

enum SectionList {
    case popular([RecipeModel])
    case category([RecipeModel])
    case random([RecipeModel])
    
    var recipes: [RecipeModel] {
        switch self {
        case .popular(let recipes),
                .category(let recipes),
                .random(let recipes):
            return recipes
        }
    }
    
    var count: Int {
        recipes.count
    }
    
    var title: String {
        switch self {
        case .popular(_):
            return "Popular recipes"
        case .category(_):
            return "Category"
        case .random(_):
            return "Random recipes"
        }
    }
    
}
