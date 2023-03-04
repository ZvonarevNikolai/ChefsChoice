//
//  FavoriteViewController.swift
//  ChefsChoice
//
//  Created by Дмитрий on 28.02.2023.
//

import UIKit
import CoreData

class FavoriteViewController: UITableViewController {
    
    private var dataManager = DataManager()
    private var recipesModel: [RecipeModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getAllRecipes({ recipes in
            DispatchQueue.main.async {
                self.recipesModel = recipes
                self.tableView.reloadData()
            }
        })
        
        tableView.register(CellForFavorite.self, forCellReuseIdentifier: "cell")
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
        return 380
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = recipesModel[indexPath.row]
        let detailVC = FavoriteDetailViewController()
        detailVC.recipeModel = recipe
        
        navigationController?.popToViewController(FavoriteDetailViewController(), animated: true)
        
    }
    
}
