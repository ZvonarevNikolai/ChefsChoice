//
//  RecipesViewController.swift
//  ChefsChoice
//
//  Created by Nikolai Zvonarev on 01.03.2023.
//

import UIKit

class RecipesViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sections = MockData.shared.pageData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Chef's Choise"
        
        view.addSubview(searchButton)
        view.addSubview(collectionView)
        collectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: "PopularCollectionViewCell")
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        collectionView.register(RandomCollectionViewCell.self, forCellWithReuseIdentifier: "RandomCollectionViewCell")
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSupplementaryView")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

//MARK: - Create Layout

extension RecipesViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else {return nil}
            let section = self.sections[sectionIndex]
            switch section {
            case .popular(_):
                return self.createPopularSection()
            case .category(_):
                return self.createCategorySection()
            case .random(_):
                return self.createRandomSection()
            }
        }
        
    }
    
    private func createLayoutSection(group: NSCollectionLayoutGroup, behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior, interGroupSpacing: CGFloat, supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem], contentInsets: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        section.supplementariesFollowContentInsets = contentInsets
        return section
    }
    
    private func createPopularSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.2)), subitems: [item])
        
        let section = createLayoutSection(group: group, behavior: .groupPaging, interGroupSpacing: 5, supplementaryItems: [supplementaryHeaderItem()], contentInsets: false)
        section.contentInsets = .init(top: 0, leading: -10, bottom: 0, trailing: 0)
        return section
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1)), subitems: [item])
        
        let section = createLayoutSection(group: group, behavior: .none, interGroupSpacing: 10, supplementaryItems: [supplementaryHeaderItem()], contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return section
    }
    
    private func createRandomSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.45)), subitems: [item])
        
        let section = createLayoutSection(group: group, behavior: .continuous, interGroupSpacing: 10, supplementaryItems: [supplementaryHeaderItem()], contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 0)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
}

//MARK: - UICollectionViewDelegate

extension RecipesViewController: UICollectionViewDelegate {
    
}

//MARK: - IUCollectionViewDataSource

extension RecipesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .popular(let popular):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath) as? PopularCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(imageName: popular[indexPath.row].image)
            return cell
            
        case .category(let category):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(categoryName: category[indexPath.row].title, imageName: category[indexPath.row].image)
            return cell
            
        case .random(let random):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomCollectionViewCell", for: indexPath) as? RandomCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(imageName: random[indexPath.row].image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as! HeaderSupplementaryView
            header.configureHeader(categoryName: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
        
    }
    
}

//MARK: - Set Constraints

extension RecipesViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -10)
        ])
    }
}


//MARK: - Preview

import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let listVC = RecipesViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) -> RecipesViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) {
        }
    }
}
