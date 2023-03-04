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

class SearchVC: UIViewController {
    
    
    //MARK: - UI Elements
    
    var filterStackView                    = UIStackView()
    var filterTitleLabel                   = UILabel()

    var ratingStackView                    = UIStackView()
    var ratingTitleLabel                   = UILabel()
    var ratingButton                       = UIButton()
    var applyButton                        = UIButton()

    var categoryStackView                  = UIStackView()
    var categoryTitleLabel                 = UILabel()
    //var categoryGrid                     = UICollectionView()
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
        
    }
    
    
    //MARK: - UI Setup Methods
    
    func setupUI() {
        
        let titleArray = [filterTitleLabel: "Filter", ratingTitleLabel: "by Rating", categoryTitleLabel: "by Category", cookingTitleLabel: "by Total Cooking Time", healthyTypeTitleLabel: "by Type"]
        
        for (key, value) in titleArray {
            configureTitleLabels(label: key, withTitle: value)
        }
        
        
        setupFilterStackView()
        configureTableView()
        
        filterTitleLabel.textAlignment = .center
        filterTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
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
        
        view.addSubview(filterStackView)
        
        setupRatingStackView()
        setupCategoryStackView()
        setupCookingTimeStackView()
        setupHealthyTypeStackView()
        
        
        filterStackView.addArrangedSubview(filterTitleLabel)
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
        for _ in 1...5 {
            let newStarBTN = UIButton()
            сonfigureRatingButtons(for: newStarBTN)
            view.addSubview(newStarBTN)
            starStack.addArrangedSubview(newStarBTN)
        }
        starStack.translatesAutoresizingMaskIntoConstraints = false
        
        ratingStackView.addArrangedSubview(hStack)
        ratingStackView.addArrangedSubview(starStack)
    }
    
    func configureGridView() {
        view.addSubview(gridPlaceholder)
        gridPlaceholder.backgroundColor = .gray
        gridPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridPlaceholder.widthAnchor.constraint(equalToConstant: 100),
            gridPlaceholder.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupCategoryStackView() {
        configureGridView()
        
        view.addSubview(categoryStackView)

        categoryStackView.axis = .vertical
        categoryStackView.addArrangedSubview(categoryTitleLabel)
        categoryStackView.addArrangedSubview(gridPlaceholder)

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


//MARK: - SUI Preview

struct FlowProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let view = SearchVC()
        func makeUIViewController(context: UIViewControllerRepresentableContext<FlowProvider.ContainterView>) -> SearchVC {
            return view
        }
        
        func updateUIViewController(_ uiViewController: FlowProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<FlowProvider.ContainterView>) {
            
        }
        
    }
    
}

