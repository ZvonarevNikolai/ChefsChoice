//
//  RandomCollectionViewCell.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import UIKit

class RandomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RandomCollectionViewCell"
    
    private let randomRecipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "recipe1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been emplemented")
    }
    
    func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(randomRecipeImageView)
    }
    
    func configureCell(imageName: String) {
        randomRecipeImageView.image = UIImage(named: imageName)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            randomRecipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            randomRecipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            randomRecipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            randomRecipeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
