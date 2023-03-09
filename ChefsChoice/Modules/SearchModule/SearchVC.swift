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
    private var filterStackTopInset: CGFloat       = 20
 
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
    
    private var categoryItems                      = [
                                                        ("Desserts", "cupcake"),
                                                        ("Soups", "hot-soup"),
                                                        ("Salads", "salad"),
                                                        ("Seafood", "seafood"),
                                                        ("Spaghetti", "spaghetti"),
                                                        ("Steak", "steak")
                                                    ]
    
    private var cookingTimeStack                   = UIStackView()
    private var cookingTitleLabel                  = UILabel()
    private var cookingTimeSlider                  = UISlider()
    private var cookingTimeLabel                   = UILabel()
    private var minimumCookingTime: Float          = 10
    private var maximumCookingTime: Float          = 100
    
    private var healthyTypeStackView               = UIStackView()
    private var healthyTypeTitleLabel              = UILabel()
    private var healthyTypeTrueButton              = UIButton()
    private var healthyTypeFalseButton             = UIButton()
    
    private var tableView                          = UITableView()
    
    
    //MARK: - Variables
    
    var passedRecipes: [RecipeModel]?              = []
    
    // these vars and methods should be refactored into Model
    private var selectedRating: Int                = 0
    //private var selectedCategory: CategoryRecipe   = .dessert
    private var selectedCategory: String           = ""
    private var selectedTimeToCook: Int            = 0
    private var selectedHealthyType: Bool          = true
        
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryGrid.dataSource = self
        categoryGrid.delegate = self
             
    }
    
    
    //MARK: - UI Setup Methods
    
    func setupUI() {
       
        view.backgroundColor = .systemBackground
        
        let titleArray = [ratingTitleLabel: "by Rating", categoryTitleLabel: "by Category", cookingTitleLabel: "by Total Cooking Time", healthyTypeTitleLabel: "by Type"]
        
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
        [healthyTypeTrueButton, healthyTypeFalseButton].forEach{$0.isSelected = false}
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
        view.addSubview(healthyTypeTrueButton)
        view.addSubview(healthyTypeFalseButton)
        
        healthyTypeTrueButton.setTitle("Healthy", for: .normal)
        healthyTypeTrueButton.setTitleColor(.label, for: .normal)
        healthyTypeTrueButton.addTarget(self, action: #selector(healthyButtonTapped(_:)), for: .touchUpInside)
        
        healthyTypeFalseButton.setTitle("Not Healthy", for: .normal)
        healthyTypeFalseButton.setTitleColor(.label, for: .normal)
        healthyTypeFalseButton.addTarget(self, action: #selector(healthyButtonTapped(_:)), for: .touchUpInside)
    }

    func setupHealthyTypeStackView() {

        configureHealthyTypeButtons()
        
        healthyTypeStackView.axis = .vertical
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        [healthyTypeTrueButton, healthyTypeFalseButton].forEach{hStack.addArrangedSubview($0)}
        
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
        
        // add fetch request
        
        print("""
                Request recipes with:
                Rating: \(selectedRating)
                Category: \(selectedCategory)
                CookingTime: \(selectedTimeToCook)
                Healthy: \(selectedHealthyType)
                """)
        resetUI()
        // reset selectedValues
        tableView.reloadData()
    }
    
    @objc func hideShowFilterViews() {
        filterTitleButton.isUserInteractionEnabled.toggle()
        
        UIView.animate(withDuration: 1, delay: 0.1) { [self] in
            [ratingStackView, categoryStackView, cookingTimeStack, healthyTypeStackView].forEach {$0.isHidden.toggle()}
            filterStackIsHidden.toggle()
            
            filterStackTopInset = filterStackIsHidden ? 0 : 20
            filterStackView.layoutMargins = UIEdgeInsets(top: filterStackTopInset, left: 20, bottom: filterStackTopInset, right: 20)
            
        }
    }
    
    @objc func ratingButtonTapped(_ sender: UIButton){
        
        ratingButtonArray.forEach{$0.setBackgroundImage(UIImage(systemName: "star"), for: .normal)}
        selectedRating = sender.tag
        
        for i in 0...sender.tag-1 {
            ratingButtonArray[i].setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
    }
    
    @objc func healthyButtonTapped(_ sender: UIButton) {
        [healthyTypeTrueButton, healthyTypeFalseButton].forEach{$0.isSelected = false}
        
        sender.isSelected = true
        if sender == healthyTypeTrueButton {
            
            sender.backgroundColor = .systemGreen
            selectedHealthyType = true
        } else {
            sender.backgroundColor = .systemRed
            selectedHealthyType = false
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell {
            
            if let randomRecipes = passedRecipes {
                
                cell.recipeNameLabel.text = randomRecipes[indexPath.row].title
                
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
    func configureTableView() {

        view.addSubview(tableView)
        
        tableView.largeContentTitle = "Search results"
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 20
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.backgroundColor = .cyan

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
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! CategoryCollectionViewCell
        cell.configureCell(categoryName: categoryItems[indexPath.item].0, imageName: categoryItems[indexPath.item].1)
        cell.layer.borderColor = UIColor.systemOrange.cgColor
        cell.layer.borderWidth = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.layer.borderColor = UIColor.red.cgColor
            selectedCategory = cell.getName().lowercased()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.layer.borderColor = UIColor.systemOrange.cgColor
            
        }
    }
}

//MARK: - SliderDelegate


