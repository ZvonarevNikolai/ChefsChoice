import UIKit

final class RandomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RandomCollectionViewCell"
    
    private let randomRecipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "recipe1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .systemGroupedBackground
        label.alpha = 0.8
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been emplemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        randomRecipeImageView.image = nil
        recipeTitleLabel.text = nil
    }
    
    func setupView() {
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 2
        addSubview(randomRecipeImageView)
        randomRecipeImageView.addSubview(recipeTitleLabel)
    }
    
    func addImageToCell(image: UIImage) {
        randomRecipeImageView.image = image
    }
    
    func configureCell(recipe: RecipeModel) {
        recipeTitleLabel.text = recipe.title
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            randomRecipeImageView.topAnchor.constraint(
                equalTo: topAnchor, constant: 0),
            randomRecipeImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 0),
            randomRecipeImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: 0),
            randomRecipeImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: 0),
            
            recipeTitleLabel.topAnchor.constraint(
                equalTo: randomRecipeImageView.topAnchor),
            recipeTitleLabel.leadingAnchor.constraint(
                equalTo: randomRecipeImageView.leadingAnchor),
            recipeTitleLabel.trailingAnchor.constraint(
                equalTo: randomRecipeImageView.trailingAnchor),
            recipeTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
