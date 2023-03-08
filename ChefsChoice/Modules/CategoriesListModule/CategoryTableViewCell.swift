//
//  CustomCell.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 07.03.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    static let identifier = "CategoryTableViewCell"

    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .label
        iv.layer.cornerRadius = 6
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: RecipeModel) {
        self.recipeLabel.text = model.title
    }
    
    public func updateImage(image: UIImage) {
        recipeImageView.image = image
    }
    
    private func setupUI() {
        self.contentView.addSubview(recipeImageView)
        self.contentView.addSubview(recipeLabel)
        
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 90),
            recipeImageView.widthAnchor.constraint(equalToConstant: 90),
            
            recipeLabel.leadingAnchor.constraint(equalTo: self.recipeImageView.trailingAnchor, constant: 16),
            recipeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            recipeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            recipeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
}
