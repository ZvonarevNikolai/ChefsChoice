//
//  SearchVC.swift
//  ChefsChoice
//
//  Created by Андрей Бородкин on 28.02.2023.
//


/// Course of action
/// 1. Finish UI Layout:
///     - fix black screen bug (rearrange views)                          DONE
///     - fix preview bug                                                               DONE
///     - add grid                                                                          DONE
///     - add tableview                                                                 DONE
///     - create custom cell                                                          DONE
///     - add animations                                                               DONE
///     - change height inset in filter stack
///     - fix hide animation for smoother experience
///     - OPTIONAL: add search bar
///     - make UI elements functional to show and get data
///  2. Get sample Data                                                                    DONE
///  3. Create model for VC to make filter functional
///  4. Connect to JSON module
///  5. Refactor View Controller into separate Views
///


import UIKit
import SwiftUI

class SearchVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    //MARK: - UI Elements
    
    private var filterStackView                    = UIStackView()
    private var filterTitleButton                  = UIButton()
    private var filterStackIsHidden                = false
    private var filterStackTopInset: CGFloat       = 5
 
    private var ratingStackView                    = UIStackView()
    private var ratingTitleLabel                   = UILabel()
    private var ratingButton                       = UIButton()
    
    private var ratingButtonArray: [UIButton]      = []
    private var applyButton                        = UIButton()

    private var categoryStackView                  = UIStackView()
    private var categoryTitleLabel                 = UILabel()
    private var categoryGrid                       = UICollectionView(frame: .zero, collectionViewLayout:                                           {
                                                    let layout = UICollectionViewFlowLayout()
                                                    layout.scrollDirection = .horizontal
                                                    return layout
                                                  }())
    
//    private var categoryItems                      = [
//                                                        ("Desserts", "cupcake"),
//                                                        ("Soups", "hot-soup"),
//                                                        ("Salads", "salad"),
//                                                        ("Seafood", "seafood"),
//                                                        ("Spaghetti", "spaghetti"),
//                                                        ("Steak", "steak")
//                                                    ]
    
    private let categoryItems = RecipesManager().categories
//    private let categoryForAPI: [CategoryRecipe] = [
//        .mainСourse, .soup, .breakfast, .salad, .dessert, .drink
//    ]
    
    private var cookingTimeStack                   = UIStackView()
    private var cookingTitleLabel                  = UILabel()
    private var cookingTimeSlider                  = UISlider()
    private var cookingTimeLabel                   = UILabel()
    private var minimumCookingTime: Float          = 15
    private var maximumCookingTime: Float          = 175
    private lazy var defaultCookingTime: Float     = { (maximumCookingTime - minimumCookingTime) / 2}()
    
    private var healthyTypeStackView               = UIStackView()
    private var healthyTypeTitleLabel              = UILabel()
    private var dietKetoButton                     = UIButton()
    private var dietVeganButton                    = UIButton()
    
    private var tableView                          = UITableView()
    
    
    //MARK: - Variables
    
    var recipeManager                              = RecipesManager()
    var passedRecipes: [RecipeModel]?              = []
    
    // these vars and methods should be refactored into Model
    private var selectedRating: Int                = 0
    func translateToLikes(_ rating: Int) -> Set<Int> {
        switch rating {
        case 1: return Set(1...10)
        case 2: return Set(11...100)
        case 3: return Set(101...200)
        case 4: return Set(201...500)
        case 5: return Set(501...)
        default: return Set(-1...0)
        }
    }
    func resetFilterData() {
        selectedRating = 0
        selectedCategory = .dessert
        selectedTimeToCook = Int(defaultCookingTime)
    }
    //private var selectedCategory: CategoryRecipe   = .dessert
    private var selectedCategory: CategoryRecipe   = .dessert
    private lazy var selectedTimeToCook: Int       = Int(defaultCookingTime)
    private var selectedDiet: Diet?
        
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryGrid.dataSource = self
        categoryGrid.delegate = self
        navigationController?.navigationBar.isHidden = true
        
        
        recipeManager.fetchRecipe(sort: .random) { [weak self] result in
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.passedRecipes = success
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
            
        }
    }
    
    
    //MARK: - UI Setup Methods
    
    func setupUI() {
       
        view.backgroundColor = .systemBackground
        
        let titleArray = [ratingTitleLabel: "by Rating", categoryTitleLabel: "by Category", cookingTitleLabel: "by Total Cooking Time", healthyTypeTitleLabel: "by Diet"]
        
        for (key, value) in titleArray {
            configureTitleLabels(label: key, withTitle: value)
        }
        
        
        setupFilterStackView()
        configureTableView()
        
        updateUI()

    }
    
    func updateUI() {
        
        //filterStackTopInset = filterStackIsHidden ? 0 : 20
        filterStackView.layoutMargins = UIEdgeInsets(top: filterStackTopInset, left: 20, bottom: filterStackTopInset, right: 20)
        
    }
    
    
    func resetUI() {
        ratingButtonArray.forEach{$0.setBackgroundImage(UIImage(systemName: "star"), for: .normal)}
        // no selection for cell
        [dietKetoButton, dietVeganButton].forEach{$0.backgroundColor = .clear}
    }
    
    // sets up main stack view
    func setupFilterStackView() {
        
        filterStackView.layer.borderColor = UIColor.black.cgColor
        filterStackView.layer.borderWidth = 1
        filterStackView.layer.cornerRadius = 20
        
        filterStackView.axis = .vertical
        filterStackView.spacing = 20
        filterStackView.alignment = .fill
        
        filterStackView.isLayoutMarginsRelativeArrangement = true
       
        view.addSubview(filterStackView)
        
        configureFilterTitleButton()
        setupRatingStackView()
        setupCategoryStackView()
        setupCookingTimeStackView()
        setupHealthyTypeStackView()
        
        
        filterStackView.addArrangedSubview(filterTitleButton)
        filterStackView.addArrangedSubview(ratingStackView)
        filterStackView.addArrangedSubview(categoryStackView)
        filterStackView.addArrangedSubview(cookingTimeStack)
        filterStackView.addArrangedSubview(healthyTypeStackView)
        
        
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            filterStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20)
        ])
    }
    
    
    
    func configureTitleLabels(label: UILabel, withTitle title: String) {
        
        view.addSubview(label)
        
        label.text = title
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureFilterTitleButton() {
        view.addSubview(filterTitleButton)
        filterTitleButton.setTitle("Filter", for: .normal)
        filterTitleButton.setTitleColor(.label, for: .normal)
        
        filterTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        filterTitleButton.isUserInteractionEnabled = false
        filterTitleButton.addTarget(self, action: #selector(hideShowFilterViews), for: .touchUpInside)
//
//        filterTitleButton.layer.borderWidth = 1
//        filterTitleButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func сonfigureRatingButtons(for button: UIButton) {
        
        view.addSubview(button)
        
        button.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        
        button.tintColor = .systemOrange
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configureApplyButton() {
        
        //view.addSubview(applyButton)
        
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.blue, for: .normal)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            applyButton.heightAnchor.constraint(equalToConstant: 20),
            applyButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupRatingStackView() {
        
        configureApplyButton()
        
        ratingStackView.axis = .vertical
        ratingStackView.distribution = .equalSpacing
        
        let hStack = UIStackView()
        view.addSubview(hStack)
        hStack.axis = .horizontal
        
        hStack.addArrangedSubview(ratingTitleLabel)
        hStack.addArrangedSubview(applyButton)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let starStack = UIStackView()
        starStack.axis = .horizontal
        starStack.distribution = .equalSpacing
        view.addSubview(starStack)
        
        for id in 1...5 {
            let newStarBTN = UIButton()
            сonfigureRatingButtons(for: newStarBTN)
            newStarBTN.tag = id
            newStarBTN.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(newStarBTN)
            starStack.addArrangedSubview(newStarBTN)
            ratingButtonArray.append(newStarBTN)
        }
        starStack.translatesAutoresizingMaskIntoConstraints = false
        
        ratingStackView.addArrangedSubview(hStack)
        ratingStackView.addArrangedSubview(starStack)
    }
    
    func configureGridView() {
        
        view.addSubview(categoryGrid)
        
        categoryGrid.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "gridCell")
        
        categoryGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryGrid.heightAnchor.constraint(equalTo: categoryGrid.widthAnchor, multiplier: 0.5)
        ])
    }
    
    func setupCategoryStackView() {
        configureGridView()
        
        view.addSubview(categoryStackView)

        categoryStackView.axis = .vertical
        categoryStackView.spacing = 10
        categoryStackView.addArrangedSubview(categoryTitleLabel)
        categoryStackView.addArrangedSubview(categoryGrid)

        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureCookingTimeSlider() {
        view.addSubview(cookingTimeSlider)
        
        cookingTimeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        cookingTimeSlider.minimumValue = minimumCookingTime
        cookingTimeSlider.maximumValue = maximumCookingTime
        cookingTimeSlider.value = defaultCookingTime
    }

    func configureCookingTimeLabel(){
        view.addSubview(cookingTimeLabel)
        
        cookingTimeLabel.text = "1 H 20 M"
        cookingTimeLabel.font = UIFont.systemFont(ofSize: 20)
        cookingTimeLabel.textColor = .label
        cookingTimeLabel.textAlignment = .center
    }

    func setupCookingTimeStackView() {
        configureCookingTimeLabel()
        configureCookingTimeSlider()
        
        cookingTimeStack.axis = .vertical
        cookingTimeStack.spacing = 10
        
        cookingTimeStack.addArrangedSubview(cookingTitleLabel)
        cookingTimeStack.addArrangedSubview(cookingTimeSlider)
        cookingTimeStack.addArrangedSubview(cookingTimeLabel)

    }

    func configureHealthyTypeButtons() {
        view.addSubview(dietKetoButton)
        view.addSubview(dietVeganButton)
        
        [dietKetoButton, dietVeganButton].forEach{ button in
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(dietButtonTapped(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 5
        }
        
        dietKetoButton.setTitle("Keto", for: .normal)
        //healthyTypeTrueButton.setTitleColor(.label, for: .normal)
       // dietKetoButton.addTarget(self, action: #selector(dietButtonTapped(_:)), for: .touchUpInside)
        
        dietVeganButton.setTitle("Vegan", for: .normal)
        //healthyTypeFalseButton.setTitleColor(.label, for: .normal)
       // healthyTypeFalseButton.addTarget(self, action: #selector(healthyButtonTapped(_:)), for: .touchUpInside)
    }

    func setupHealthyTypeStackView() {

        configureHealthyTypeButtons()
        
        healthyTypeStackView.axis = .vertical
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.contentMode = .center
        hStack.spacing = 10
        hStack.distribution = .fillEqually
        [dietKetoButton, dietVeganButton].forEach{hStack.addArrangedSubview($0)}
        
        healthyTypeStackView.addArrangedSubview(healthyTypeTitleLabel)
        healthyTypeStackView.addArrangedSubview(hStack)
    }
    
    
   @objc func sliderValueChanged(_ sender: UISlider) {
       
       let minutes: Int = Int(sender.value)
       selectedTimeToCook = minutes
       let timeToCook: (hours: Int, minutes: Int) = (minutes / 60, (minutes % 60))
       
       cookingTimeLabel.text = String("\(timeToCook.hours)H \(timeToCook.minutes) M")
    }
    
    //MARK: - Button Methods
    
    @objc func applyButtonTapped() {
        hideShowFilterViews()
        
        recipeManager.fetchRecipeFilter(category: selectedCategory, sort: .time, number: 100, maxReadyTime: selectedTimeToCook, diet: selectedDiet) { [weak self] result in
            
            switch result {
            case .success(let success):
                
                self?.passedRecipes = success
                
                if self?.selectedRating ?? 0 > 0 {
                    self?.passedRecipes = self?.passedRecipes?.filter({ [weak self] recipe in
                        self!.translateToLikes(self!.selectedRating).contains(recipe.aggregateLikes!)
                    })
                }
            case .failure(_):
                break
            }
            
        }
        // add fetch request
        
        print("""
                Request recipes with:
                Rating: \(selectedRating)
                Category: \(selectedCategory)
                CookingTime: \(selectedTimeToCook)
                Healthy: \(String(describing: selectedDiet))
                """)
        resetUI()
        resetFilterData()
        // reset selectedValues
        tableView.reloadData()
    }
    
    @objc func hideShowFilterViews() {
        filterTitleButton.isUserInteractionEnabled.toggle()
        
        UIView.animateKeyframes(withDuration: 0.8, delay: 0.1, options: [], animations: { [weak self] in
            var relativeStartTime = 0.00
            [self!.ratingStackView, self!.categoryStackView, self!.cookingTimeStack, self!.healthyTypeStackView].forEach { stack in
                
                UIView.addKeyframe(withRelativeStartTime: relativeStartTime, relativeDuration: 0.5) {
                    stack.isHidden.toggle()
                    stack.layer.opacity = self!.filterStackIsHidden ? 1 : 0
                    relativeStartTime += 0.33
                }
            }
        })
        // changes filterStack top and bottom insets
        filterStackIsHidden.toggle()
//        filterStackTopInset = filterStackIsHidden ? 0 : 20
//        filterStackView.layoutMargins = UIEdgeInsets(top: filterStackTopInset, left: 20, bottom: filterStackTopInset, right: 20)
    }
    
    @objc func ratingButtonTapped(_ sender: UIButton){
        
        ratingButtonArray.forEach{$0.setBackgroundImage(UIImage(systemName: "star"), for: .normal)}
        selectedRating = sender.tag
        
        for i in 0...sender.tag-1 {
            ratingButtonArray[i].setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
    }
    
    @objc func dietButtonTapped(_ sender: UIButton) {
        [dietKetoButton, dietVeganButton].forEach{$0.isSelected = false}
        [dietKetoButton, dietVeganButton].forEach{$0.backgroundColor = .clear}
        
        sender.isSelected = true
        if sender == dietKetoButton {
            
            sender.backgroundColor = .systemBlue
            selectedDiet = .keto
        } else {
            sender.backgroundColor = .systemGreen
            selectedDiet = .vegan
        }
        
    }
      
}


//MARK: - TableView Setup

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let randomRecipes = passedRecipes {
            return randomRecipes.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryTableViewCell {
            
            if let trueRecipes = passedRecipes {
                
                let recipe = trueRecipes[indexPath.row]
                
                
                //cell.recipeNameLabel.text = trueRecipes[indexPath.row].title
                //let cookingTime = trueRecipes[indexPath.row].readyInMinutes
                //cell.cookingTimeCookLabel.text = String(cookingTime!)
                
                recipeManager.fetchImage(id: trueRecipes[indexPath.row].id, size: .size240x150) { image in
                    DispatchQueue.main.async {
                        //cell.recipeImageView.image = image
                        cell.updateImage(image: image)
                    }
                }
                cell.configure(model: recipe)
                
                return cell
            }
            
            
            
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Search results"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if let recipe = passedRecipes?[indexPath.row] {
            let detailVC = DetailViewController(recipeModel: recipe)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(detailVC, animated: true)
                detailVC.configure(id: recipe.id)
                
                detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.dismissView))
              //TODO: Figure out how to get back button
            }
        }
        
    }
    
    @objc func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureTableView() {

        view.addSubview(tableView)
        
        tableView.largeContentTitle = "Search results"
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 20
        tableView.layer.borderColor = UIColor.black.cgColor
        //tableView.backgroundColor = .cyan

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

//MARK: - CollectionView Setup

extension SearchVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! CategoryCollectionViewCell
        cell.configureCell(categoryName: categoryItems[indexPath.row].title, imageName: categoryItems[indexPath.row].image!)
        cell.layer.borderColor = UIColor.systemOrange.cgColor
        cell.layer.borderWidth = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.layer.borderColor = UIColor.red.cgColor
            let categoryName = cell.getName().lowercased()
            
            let correctCategoryName = categoryName.replacingOccurrences(of: " ", with: "_")
            selectedCategory = CategoryRecipe(rawValue: cell.getName().lowercased()) ?? .dessert
            //selectedCategory = categoryForAPI[indexPath.row]
           print(correctCategoryName)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath)
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.layer.borderColor = UIColor.systemOrange.cgColor
        }
    }
}

