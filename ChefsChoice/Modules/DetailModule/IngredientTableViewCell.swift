import UIKit

final class IngredientTableViewCell: UITableViewCell {
    
    static let identifier = "IngredientTableViewCell"
    
    private let ingredientLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(ingredientLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with ingredient: Ingredient) {
        ingredientLabel.text = ingredient.name
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            ingredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ingredientLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 8),
            ingredientLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -8)
        ])
    }
    
}
