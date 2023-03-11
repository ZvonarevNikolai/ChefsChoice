//
//  RecipeTableViewCell.swift
//  ChefsChoice
//
//  Created by Андрей Бородкин on 02.03.2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    
    
    let recipeImageView                 = UIImageView()
    
    let cellStack                       = UIStackView()
    let recipeNameLabel                 = UILabel()
    
    let middleStack                     = UIStackView()
    let cookingTimeStack                = UIStackView()
    let cookingTimeTotalTitleLabel      = UILabel()
    let cookingTimeTotalLabel           = UILabel()
    let cookingTimePrepTitleLabel       = UILabel()
    let cookingTimePrepLabel            = UILabel()
    let cookingTimeCookTitleLabel       = UILabel()
    let cookingTimeCookLabel            = UILabel()
    
    let auxInfoStack                    = UIStackView()
    let categoryTitleLabel              = UILabel()
    let categoryLabel                   = UILabel()
    let healthyTypeTitleLabel           = UILabel()
    let healthyTypeLabel                = UILabel()
    
    let ratingStack                     = UIStackView()
    let ratingTitleLabel                = UILabel()
    let ratingArray: [UIImageView]      = []
    
    var passedRecipe: RecipeModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(withName name: String, image: String) {
        recipeNameLabel.text = name
        recipeImageView.image = UIImage(imageLiteralResourceName: image)
    }
    
    //MARK: - UI setup
    func setupUI() {
        
        configureImage()
        setupCellStack()
    }
    
    func configureImage() {
        contentView.addSubview(recipeImageView)
        
        recipeImageView.image = UIImage(systemName: "cart")
        recipeImageView.layer.borderColor = UIColor.black.cgColor
        recipeImageView.layer.borderWidth = 5
        recipeImageView.layer.cornerRadius = 10
        
        
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 100),
            recipeImageView.widthAnchor.constraint(equalToConstant: 100)
        
        ])
    }
    
    func setupCellStack() {
        contentView.addSubview(cellStack)
        
        configureRecipeNameLabel()
        
        cellStack.addArrangedSubview(recipeNameLabel)
        cellStack.addSubview(cookingTimeCookLabel)
        
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 20),
            cellStack.topAnchor.constraint(equalTo: recipeImageView.topAnchor)
        
        ])
    }
    
    func configureRecipeNameLabel(){
        contentView.addSubview(recipeNameLabel)
        
        recipeNameLabel.text = "Recipe Name"
        recipeNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        recipeNameLabel.textColor = .label
    }
  
}
