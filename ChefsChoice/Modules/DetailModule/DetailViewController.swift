//
//  DetailViewController.swift
//  ChefsChoice
//

//  Created by Дмитрий on 02.03.2023.

//

import UIKit

class DetailViewController: UIViewController {

    
    var stepsModel: StepsModel!
    var testModel = StepsModel.steps
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "notFavorite"), for: .normal)
        button.addTarget(self, action: #selector(addFavoriteRecipe), for: .touchUpInside)
        return button
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "carrot.fill")
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
    
    private let informationTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.font = .systemFont(ofSize: 16)
        textView.isHidden = false
        textView.isEditable = false
        textView.text = "You can never have too many Chinese recipes, so give Cauliflower, Brown Rice, and Vegetable Fried Rice a try. This recipe serves 8 and costs $1.12 per serving. This hor d'oeuvre has <b>192 calories</b>, <b>7g of protein</b>, and <b>6g of fat</b> per serving. Head to the store and pick up broccoli, sesame seeds, soy sauce, and a few other things to make it today. 3689 people were impressed by this recipe. It is brought to you by fullbellysisters.blogspot.com. It is a good option if you're following a <b>gluten free, dairy free, lacto ovo vegetarian, and vegan</b> diet. From preparation to the plate, this recipe takes roughly <b>30 minutes</b>. Overall, this recipe earns a <b>spectacular spoonacular score of 100%</b>. If you like this recipe, you might also like recipes such as <a href=\"https://spoonacular.com/recipes/cauliflower-brown-rice-and-vegetable-fried-rice-1584601\">Cauliflower, Brown Rice, and Vegetable Fried Rice</a>, <a href=\"https://spoonacular.com/recipes/cauliflower-brown-rice-and-vegetable-fried-rice-1238897\">Cauliflower, Brown Rice, and Vegetable Fried Rice</a>, and <a href=\"https://spoonacular.com/recipes/cauliflower-brown-rice-and-vegetable-fried-rice-1230097\">Cauliflower, Brown Rice, and Vegetable Fried Rice</a>."
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
        label.text = "Servings: \(testModel.servings)\n\nCooking time: \(testModel.readyInMinutes) minutes"
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
    
    @objc private func addFavoriteRecipe(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "notFavorite") {
            sender.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "notFavorite"), for: .normal)
        }
    }
    
    private func addStepsModel() {
        stepsStackView.addArrangedSubview(titleLabel)
        
        for step in testModel.analyzedInstructions {
            lazy var stepLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = .systemFont(ofSize: 16, weight: .medium)
                let textLabel = NSMutableAttributedString(string: "Step: \(step.stepNumber)\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold)])
                textLabel.append(NSMutableAttributedString(string: "\(step.stepInformation)\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
                textLabel.append(NSMutableAttributedString(string: "Ingredients: ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
                textLabel.append(NSMutableAttributedString(string: "\(step.ingredients[0].name)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
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
            informationTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            stepsScrollView.topAnchor.constraint(equalTo: headingView.bottomAnchor),
            stepsScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stepsScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stepsScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
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
