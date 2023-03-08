//
//  RecipesListViewController.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 07.03.2023.
//

import UIKit

class CategoriesListViewController: UIViewController {

    //MARK: - Variables
    
    private let recipeModel: [RecipeModel]?
    private let recipeImages: [UIImage]?
    
    private let images: [UIImage] = [
        UIImage(named: "4693469")!,
        UIImage(named: "4693469")!,
        UIImage(named: "4693469")!,
        UIImage(named: "4693469")!,
        UIImage(named: "4693469")!,
    ]
    
    //MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = true
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        return tableView
    }()
    
    init(model: [RecipeModel], recipeImage: [UIImage]?) {
        self.recipeModel = model
        self.recipeImages = recipeImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        title = "Categories"
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    //MARK: - Setup UI
    private func setupUI() {
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CategoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipeModel?[indexPath.row]
                
        guard let recipe = recipe else {
            return UITableViewCell()
        }
        
        RecipesManager().fetchImage(id: recipe.id, size: .size90x90) { image in
            DispatchQueue.main.async {
                cell.updateImage(image: image)
            }
        }
        
        cell.configure(model: recipe)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            let vc = DetailViewController(
                recipeModel: self.recipeModel?[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
