//
//  SearchVC.swift
//  ChefsChoice
//
//  Created by Андрей Бородкин on 28.02.2023.
//


/// Course of action
/// 1. Finish UI Layout:
///     - fix black screen bug (rearrange views)
///     - fix preview bug
///     - add grid
///     - add tableview
///     - create custom cell
///     - add animations
///  2. Get sample Data
///  3. Create model for VC to make filter functional
///  4. Connect to JSON module
///  5. Refactor View Controller into separate Views
///


import UIKit
import SwiftUI

class SearchVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    //MARK: - UI Elements
    
    var filterStackView                    = UIStackView()
    var filterTitleButton                  = UIButton()
    //var filterTitleLabel                   = UILabel()

    var ratingStackView                    = UIStackView()
    var ratingTitleLabel                   = UILabel()
    var ratingButton                       = UIButton()
    
    var ratingButtonArray: [UIButton]      = []
    var applyButton                        = UIButton()

    var categoryStackView                  = UIStackView()
    var categoryTitleLabel                 = UILabel()
    var categoryGrid                       = UICollectionView(frame: .zero, collectionViewLayout: {
    let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }())
    
    var gridPlaceholder                    = UIView()
    
    var cookingTimeStack                   = UIStackView()
    var cookingTitleLabel                  = UILabel()
    var cookingTimeSlider                  = UISlider()
    var cookingTimeLabel                   = UILabel()
    
    var healthyTypeStackView               = UIStackView()
    var healthyTypeTitleLabel              = UILabel()
    var healthyTypeButton                  = UIButton()
    
    var tableView                          = UITableView()
    
    
    //MARK: - Variables
    
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryGrid.dataSource = self
        categoryGrid.delegate = self
        tap.delegate = self
    }
    
    
    //MARK: - UI Setup Methods
    
    func setupUI() {
       
        view.backgroundColor = .systemBackground
        // removed [filterTitleLabel: "Filter",]  from array
        let titleArray = [ratingTitleLabel: "by Rating", categoryTitleLabel: "by Category", cookingTitleLabel: "by Total Cooking Time", healthyTypeTitleLabel: "by Type"]
        
        for (key, value) in titleArray {
            configureTitleLabels(label: key, withTitle: value)
        }
        
        
        setupFilterStackView()
        configureTableView()
        
//        filterTitleLabel.textAlignment = .center
//        filterTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
//        filterTitleLabel.isUserInteractionEnabled = true
        //filterTitleLabel.addGestureRecognizer(tap)
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
        filterStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        //filterStackView.addGestureRecognizer(tap)
        
        view.addSubview(filterStackView)
        
        configureFilterTitleButton()
        setupRatingStackView()
        setupCategoryStackView()
        setupCookingTimeStackView()
        setupHealthyTypeStackView()
        
        
        //filterStackView.addArrangedSubview(filterTitleLabel)
        filterStackView.addArrangedSubview(filterTitleButton)
        filterStackView.addArrangedSubview(ratingStackView)
                //filterStackView.addArrangedSubview(ratingButton)
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
        //сonfigureRatingButtons()
        
        ratingStackView.axis = .vertical
        //ratingStackView.alignment = .trailing
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
        
    //TODO: find out how to better add buttons to stack
        for id in 1...5 {
            let newStarBTN = UIButton()
            сonfigureRatingButtons(for: newStarBTN)
            newStarBTN.tag = id
            view.addSubview(newStarBTN)
            starStack.addArrangedSubview(newStarBTN)
            ratingButtonArray.append(newStarBTN)
        }
        starStack.translatesAutoresizingMaskIntoConstraints = false
        
        ratingStackView.addArrangedSubview(hStack)
        ratingStackView.addArrangedSubview(starStack)
    }
    
    func configureGridView() {
//        view.addSubview(gridPlaceholder)
//        gridPlaceholder.backgroundColor = .gray
//        gridPlaceholder.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            gridPlaceholder.widthAnchor.constraint(equalToConstant: 100),
//            gridPlaceholder.heightAnchor.constraint(equalToConstant: 200)
//        ])
        
        view.addSubview(categoryGrid)
        
        categoryGrid.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "gridCell")
        //categoryGrid.backgroundColor = .black
        
        
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
        //categoryStackView.addArrangedSubview(gridPlaceholder)
        categoryStackView.addArrangedSubview(categoryGrid)

        //TODO: Add proper Grid
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureCookingTimeSlider() {
        view.addSubview(cookingTimeSlider)
        
        // further customisation
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
        view.addSubview(healthyTypeButton)
        
        healthyTypeButton.setTitle("Healthy", for: .normal)
        healthyTypeButton.setTitleColor(.label, for: .normal)
    }

    func setupHealthyTypeStackView() {

        configureHealthyTypeButtons()
        
        healthyTypeStackView.axis = .vertical
        
        healthyTypeStackView.addArrangedSubview(healthyTypeTitleLabel)
        healthyTypeStackView.addArrangedSubview(healthyTypeButton)
    }
    
    
    //MARK: - Button Methods
    
    @objc func applyButtonTapped() {
        hideShowFilterViews()
    }
    
    @objc func hideShowFilterViews() {
        filterTitleButton.isUserInteractionEnabled.toggle()
        UIView.animate(withDuration: 1, delay: 0.1) { [self] in
            [ratingStackView, categoryStackView, cookingTimeStack, healthyTypeStackView].forEach {$0.isHidden.toggle()}
//        } completion: { _ in
//            UIView.animate(withDuration: 2, delay: 0.2) {[self] in
//                [ratingStackView, categoryStackView, cookingTimeStack, healthyTypeStackView].forEach {$0.isHidden.toggle()}
//            }
        }
    }
    
    let tap = UITapGestureRecognizer(target: SearchVC.self, action: #selector(handleTap))
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
         print("Hello World")
      }
}


//MARK: - TableView Setup

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell {
            
            return cell
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
        cell.configureCell(categoryName: "Seafood", imageName: "seafood")
        cell.layer.borderColor = UIColor.systemOrange.cgColor
        cell.layer.borderWidth = 5
        
        return cell
    }
    
    
}

