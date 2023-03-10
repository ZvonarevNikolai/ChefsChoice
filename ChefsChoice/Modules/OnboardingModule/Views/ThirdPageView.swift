import UIKit

final class ThirdPageView: UIView {
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "Tasty recipes from around the world"
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
       }()
    
    let secondPageLabel: UILabel = {
        let label = UILabel()
        label.text = "Get recipes based on your tastes, goals and preferences"
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
       }()
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "slide3")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        addSubviewWithoutAutoresizingMask(backImageView)
        addSubviewWithoutAutoresizingMask(pageLabel)
        addSubviewWithoutAutoresizingMask(secondPageLabel)
        
        NSLayoutConstraint.activate([
            pageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  30),
            pageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            pageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            secondPageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  30),
            secondPageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            secondPageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  35),
            secondPageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            backImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
