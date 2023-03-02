//
//  PopularCollectionViewCell.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    private let popularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
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
        backgroundColor = .systemBackground
        addSubview(popularImageView)
    }
    
    func configureCell(imageName: String) {
        popularImageView.image = UIImage(named: imageName)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            popularImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            popularImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            popularImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            popularImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
