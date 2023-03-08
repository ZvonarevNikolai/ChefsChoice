//
//  CustomCell.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 07.03.2023.
//

import UIKit

class CustomCell: UITableViewCell {

    static let identifier = "CustomCell"

    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .label
        return iv
    }()
    
    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: UIImage, and label: String) {
        self.recipeImageView.image = image
        self.recipeLabel.text = label
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
