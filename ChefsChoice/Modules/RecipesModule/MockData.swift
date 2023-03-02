//
//  MockData.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import Foundation

struct MockData {
   
    static let shared = MockData()
    
    private let popular: SectionList = {
        .popular([.init(title: "", image: "4693469"),
                  .init(title: "", image: "4693469"),
                  .init(title: "", image: "4693469")
                 ])
    }()
    
    private let category: SectionList = {
        .category([.init(title: "Soup", image: "hot-soup"),
                   .init(title: "Pasta", image: "spaguetti"),
                   .init(title: "Salad", image: "salad"),
                   .init(title: "Seafood", image: "seafood"),
                   .init(title: "Steak", image: "steak"),
                   .init(title: "Dessert", image: "cupcake"),
                  ])
    }()
    
    private let random: SectionList = {
        .random([.init(title: "", image: "4693469"),
                 .init(title: "", image: "4693469"),
                 .init(title: "", image: "4693469")
        ])
    }()
    
    var pageData: [SectionList] {
        [popular, category, random]
    }
}
