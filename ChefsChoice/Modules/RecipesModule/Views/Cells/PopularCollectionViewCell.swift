//
//  PopularCollectionViewCell.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import UIKit

final class PopularCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PopularCollectionViewCell"
    
    private let popularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.text = "Example recipe"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var titleLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been emplemented")
    }
    
    func setupView() {
        backgroundColor = .systemBackground
        addSubview(titleLabelView)
        addSubview(popularImageView)
    }
    
    func configureCell(model: RecipeModel) {
        titleLabel.text = model.title
    }
    
    func addImageToCell(image: UIImage) {
        popularImageView.image = image
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabelView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabelView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: titleLabelView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabelView.trailingAnchor, constant: -10),
            
            popularImageView.topAnchor.constraint(equalTo: topAnchor),
            popularImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            popularImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            popularImageView.bottomAnchor.constraint(equalTo: titleLabelView.topAnchor)
        ])
    }
}
