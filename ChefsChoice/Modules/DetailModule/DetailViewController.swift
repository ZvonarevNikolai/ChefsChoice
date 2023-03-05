//
//  DetailViewController.swift
//  ChefsChoice
//

//  Created by Дмитрий on 02.03.2023.

//

import UIKit

class DetailViewController: UIViewController {
    
    private var recipeModel: RecipeModel!
    
    var manager: RecipesManager?
    
    init(recipeModel: RecipeModel!, image: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.recipeModel = recipeModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "notFavorite"), for: .normal)
        button.addTarget(self, action: #selector(addFavoriteRecipe), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let minutesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .yellow
        label.text = "20 minutes"
        return label
    }()
    
    private let headingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let nameRecipeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Seblak Bandung"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var informationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Information", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stepsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Steps", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        return button
    }()
    
    private let headingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var informationTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.font = .systemFont(ofSize: 16)
        textView.isHidden = false
        textView.isEditable = false
        print(recipeModel.summary)
        textView.text = recipeModel.summary?
            .replacingOccurrences(of: "<b>", with: " ")
            .replacingOccurrences(of: "</b>", with: " ").replacingOccurrences(of: "<a href=", with: " ")
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    private let stepsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.isHidden = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Servings: \(recipeModel.servings ?? 0)\n\nCooking time: \(recipeModel.readyInMinutes ?? 0) minutes"
        label.numberOfLines = 0
        return label
    }()
    
    private let stepsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stepsScrollView.delegate = self
        view.backgroundColor = .white
        setupConstraints()
        addStepsModel()
        manager = RecipesManager()
    }
    
    @objc private func showDetail(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            informationButton.backgroundColor = .gray
            informationButton.setTitleColor(.white, for: .normal)
            stepsButton.backgroundColor = .white
            stepsButton.setTitleColor(.black, for: .normal)
            informationTextView.isHidden = false
            stepsScrollView.isHidden = true
        case 2:
            informationButton.backgroundColor = .white
            informationButton.setTitleColor(.black, for: .normal)
            stepsButton.backgroundColor = .gray
            stepsButton.setTitleColor(.white, for: .normal)
            informationTextView.isHidden = true
            stepsScrollView.isHidden = false
        default:
            break
        }
    }
    
    func configure(id: Int) {
        DispatchQueue.main.async {
            self.manager!.fetchImage(id: id, size: .size636x393) { image in
                self.photoImageView.image = image
            }
        }
    }
    
    @objc private func addFavoriteRecipe(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "notFavorite") {
            sender.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "notFavorite"), for: .normal)
        }
    }
    
    private func addStepsModel() {
        stepsStackView.addArrangedSubview(titleLabel)
        
        for step in recipeModel.analyzedInstructions?[0].steps ?? [] {
            lazy var stepLabel: UILabel = {
                let label = UILabel()
                var ingridients: [String] = []
                step.ingredients.forEach { ingridient in
                    ingridients.append(ingridient.name)
                }
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = .systemFont(ofSize: 16, weight: .medium)
                let textLabel = NSMutableAttributedString(string: "Step: \(step.number)\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold)])
                textLabel.append(NSMutableAttributedString(string: "\(step.step)\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
                textLabel.append(NSMutableAttributedString(string: "Ingredients: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
                //textLabel.append(NSMutableAttributedString(string: "\(step.ingredients[0].name)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
                textLabel.append(NSMutableAttributedString(string: "\(ingridients.joined(separator: ", "))", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
                label.attributedText = textLabel
                label.numberOfLines = 0
                return label
            }()
            stepsStackView.addArrangedSubview(stepLabel)
        }
    }

    private func setupConstraints() {
        view.addSubview(photoImageView)
        view.addSubview(minutesLabel)
        view.addSubview(headingView)
        headingView.addSubview(nameRecipeLabel)
        headingStackView.addArrangedSubview(informationButton)
        headingStackView.addArrangedSubview(stepsButton)
        headingView.addSubview(headingStackView)
        headingView.addSubview(separatorView)
        headingView.addSubview(favoriteButton)
        view.addSubview(informationTextView)
        view.addSubview(stepsScrollView)
        stepsScrollView.addSubview(stepsStackView)
        
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            minutesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minutesLabel.bottomAnchor.constraint(equalTo: headingView.topAnchor, constant: -20),
            
            headingView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -(1/3)*view.frame.width),
            headingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headingView.heightAnchor.constraint(equalToConstant: 100),
            
            nameRecipeLabel.topAnchor.constraint(equalTo: headingView.topAnchor, constant: 8),
            nameRecipeLabel.leftAnchor.constraint(equalTo: headingView.leftAnchor, constant: 20),
            nameRecipeLabel.rightAnchor.constraint(equalTo: headingView.rightAnchor, constant: -20),
            
            headingStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 6),
            headingStackView.leftAnchor.constraint(equalTo: headingView.leftAnchor, constant: 20),
            headingStackView.rightAnchor.constraint(equalTo: headingView.rightAnchor, constant: -20),
            headingStackView.bottomAnchor.constraint(equalTo: headingView.bottomAnchor, constant: -3),
            
            separatorView.topAnchor.constraint(equalTo: nameRecipeLabel.bottomAnchor, constant: 6),
            separatorView.leftAnchor.constraint(equalTo: headingView.leftAnchor, constant: 35),
            separatorView.rightAnchor.constraint(equalTo: headingView.rightAnchor, constant: -35),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            informationTextView.topAnchor.constraint(equalTo: headingView.bottomAnchor),
            informationTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            informationTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            informationTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            stepsScrollView.topAnchor.constraint(equalTo: headingView.bottomAnchor),
            stepsScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stepsScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stepsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stepsStackView.topAnchor.constraint(equalTo: stepsScrollView.topAnchor),
            stepsStackView.leftAnchor.constraint(equalTo: stepsScrollView.leftAnchor),
            stepsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stepsStackView.bottomAnchor.constraint(equalTo: stepsScrollView.bottomAnchor),
            
            favoriteButton.centerYAnchor.constraint(equalTo: headingView.topAnchor),
            favoriteButton.centerXAnchor.constraint(equalTo: headingView.rightAnchor, constant: -60)
        ])
    }

}

extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }

}
