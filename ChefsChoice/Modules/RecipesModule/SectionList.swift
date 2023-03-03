//
//  SectionList.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import Foundation

enum SectionList {
    case popular([ItemList])
    case category([ItemList])
    case random([ItemList])
    
    var items: [ItemList] {
        switch self {
        case .popular(let items),
                .category(let items),
                .random(let items):
            return items
        }
    }
    
    var count: Int {
        items.count
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
