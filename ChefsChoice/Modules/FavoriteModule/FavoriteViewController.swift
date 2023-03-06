//
//  FavoriteViewController.swift
//  ChefsChoice
//
//  Created by Дмитрий on 28.02.2023.
//

import UIKit
import CoreData

class FavoriteViewController: UITableViewController {
    
    private var context = CoreDataManager.shared.context

    private var recipesModel: [RecipeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellForFavorite.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.fetchAllRecipes()
    }
    
    func fetchAllRecipes() {
            
            context.perform {
                let recipeEntities = try? RecipeEntity.allRecipesEntity(self.context)
                
                let dBRecipes = recipeEntities?.map({RecipeModel(
                    id: Int($0.id),
                    title: $0.title ?? "",
                    image: nil,
                    preparationMinutes: nil,
                    readyInMinutes: Int($0.readyInMinutes),
                    veryHealthy: nil,
                    aggregateLikes: Int($0.aggregateLikes),
                    servings: Int($0.servings),
                    analyzedInstructions: nil,
                    summary: $0.summary)})
                self.recipesModel = dBRecipes ?? []
                self.tableView.reloadData()
            }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellForFavorite
        let myModel = recipesModel[indexPath.row]
        cell?.configure(myModel)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = recipesModel[indexPath.row]
        let detailVC = FavoriteDetailViewController(recipeModel: recipe, image: nil)
        detailVC.recipeModel = recipe
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
