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
    //var categoryGrid                       = UICollectionView()
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
        
    }
    
    
    //MARK: - UI Setup Methods
    
    func setupUI() {
        
        let titleArray = [filterTitleLabel: "Filter", ratingTitleLabel: "by Rating", categoryTitleLabel: "by Category", cookingTitleLabel: "by Total Cooking Time", healthyTypeTitleLabel: "by Type"]
        
        for (key, value) in titleArray {
            configureTitleLabels(label: key, withTitle: value)
        }
        
        setupFilterStackView()
        configureTableView()
    }
    
    func configureTitleLabels(label: UILabel, withTitle title: String) {
        
        view.addSubview(label)
        
        label.text = title
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func сonfigureRatingButtons() {
        
        view.addSubview(ratingButton)
        
        ratingButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        ratingButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .selected)
        
        ratingButton.clipsToBounds = true
        ratingButton.layer.borderWidth = 1
        ratingButton.layer.borderColor = UIColor.black.cgColor
        
        ratingButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureApplyButton() {
        
        view.addSubview(applyButton)
        
        applyButton.setTitle("Apply", for: .normal)
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRatingStackView() {
        
        configureApplyButton()
        
        let hStack = UIStackView()
        view.addSubview(hStack)
        hStack.addArrangedSubview(ratingTitleLabel)
        hStack.addArrangedSubview(applyButton)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let starStack = UIStackView()
        view.addSubview(starStack)
        
    //TODO: find out how to better add buttons to stack
        for _ in 1...5 {
            starStack.addArrangedSubview(ratingButton)
        }
        starStack.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func configureGridView() {
        view.addSubview(gridPlaceholder)
        gridPlaceholder.backgroundColor = .black
        gridPlaceholder.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupCategoryStackView() {
        view.addSubview(categoryStackView)
        
        categoryStackView.addArrangedSubview(categoryTitleLabel)
        categoryStackView.addArrangedSubview(gridPlaceholder)
        
        //TODO: Add proper Grid
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCookingTimeSlider() {
        
    }
    
    func configureCookingTimeLabel(){
        
    }
    
    func setupCookingTimeStackView() {
        
        configureCookingTimeLabel()
        configureCookingTimeSlider()
    }
    
    func configureHealthyTypeButtons() {
        
    }
    
    func setupHealthyTypeStackView() {
        
        configureHealthyTypeButtons()
    }
    
    
    func setupFilterStackView() {
        
        view.addSubview(filterStackView)
        
        setupRatingStackView()
        setupCategoryStackView()
        setupCookingTimeStackView()
        setupHealthyTypeStackView()
        
        
        filterStackView.addArrangedSubview(ratingStackView)
        filterStackView.addArrangedSubview(categoryStackView)
        filterStackView.addArrangedSubview(cookingTimeStack)
        filterStackView.addArrangedSubview(healthyTypeStackView)
        
        
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 20),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

