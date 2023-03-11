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
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var checked: Bool = false {
        didSet {
            accessoryType = checked ? .checkmark : .none
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(ingredientLabel)
        addSubview(amountLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with ingredient: Ingredient) {
        ingredientLabel.text = ingredient.name.capitalizingFirstLetter()
        amountLabel.text = "\(ingredient.amount.metric.value)   \(ingredient.amount.metric.unit)"
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            ingredientLabel.topAnchor.constraint(
                equalTo: topAnchor, constant: 4),
            ingredientLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 8),
            ingredientLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -8),
            
            amountLabel.topAnchor.constraint(
                equalTo: ingredientLabel.bottomAnchor, constant: 8),
            amountLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -8)
        ])
    }
    
}
