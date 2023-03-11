import UIKit
import ProgressHUD


final class RecipesViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search recipe"
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var dataManager: RecipesManager?
    
    private var popularRecipes = [RecipeModel]()
    private var categories = [RecipeModel]()
    private var randomRecipes = [RecipeModel]()
    private var categoryRescipes: [CategoryRecipe] = [
        .mainСourse, .soup, .breakfast, .salad, .dessert, .drink
    ]
    
    private var sections: [SectionList] {
        [.popular(popularRecipes),
         .category(categories),
         .random(randomRecipes)]
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        setUpSearchBar()
        dataManager = RecipesManager()
        categories = dataManager?.categories ?? []
        ProgressHUD.showSucceed()
        updateRecipes()
    }
    
    // MARK: - Appearance
    
    private func setupViews() {
        title = "Chef's Choise"
        view.addSubview(collectionView)
        collectionView.register(
            PopularCollectionViewCell.self,
            forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(
            RandomCollectionViewCell.self,
            forCellWithReuseIdentifier: RandomCollectionViewCell.identifier)
        collectionView.register(
            HeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderSupplementaryView")
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setUpSearchBar() {
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.tintColor = .label
        searchBar.delegate = self
    }
    
    private func updateRecipes() {
        dataManager?.fetchRecipe(sort: .popularity) { [weak self] result in
            switch result {
            case .success(let success):
                ProgressHUD.dismiss()
                self?.popularRecipes = success
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let failure):
                ProgressHUD.dismiss()
                print(failure.localizedDescription)
            }
        }
        
        dataManager?.fetchRecipe(sort: .random) { [weak self] result in
            switch result {
            case .success(let success):
                ProgressHUD.showSucceed()
                self?.randomRecipes = success
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let failure):
                ProgressHUD.dismiss()
                print(failure.localizedDescription)
            }
        }
    }
}

extension RecipesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel", style: .done,
            target: self, action: #selector(cancelButtonDidTap))
    }
    
    @objc private func cancelButtonDidTap() {
        searchBar.text = nil
        navigationItem.rightBarButtonItem = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
        guard let text = searchBar.text else { return }
        
        dataManager?.fetchRecipe(word: text, sort: .popularity,
                                 completion: { result in
            switch result {
            case .success(let recipes):
                let categoriesVC = CategoriesListViewController(model: recipes, recipeImage: nil, title: text)
                searchBar.text = nil
                self.navigationController?.pushViewController(categoriesVC, animated: true)
            case .failure(_):
                print("error")
            }
        })
        searchBar.resignFirstResponder()
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
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        interGroupSpacing: CGFloat,
        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
        contentInsets: Bool) -> NSCollectionLayoutSection {
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = behavior
            section.interGroupSpacing = interGroupSpacing
            section.boundarySupplementaryItems = supplementaryItems
            section.supplementariesFollowContentInsets = contentInsets
            return section
        }
    
    // Popular
    private func createPopularSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(0.4)), subitems: [item])
        group.contentInsets.bottom = 16
        
        let section = createLayoutSection(
            group: group, behavior: .groupPaging, interGroupSpacing: 5,
            supplementaryItems: [supplementaryHeaderItem()], contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 0)
        return section
    }
    
    // Category
    private func createCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .absolute(150)))
        item.contentInsets.bottom = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(150)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 30
        
        return section
    }
    
    // Random
    private func createRandomSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 2
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalHeight(0.3)), subitems: [item])
        
        let section = createLayoutSection(
            group: group, behavior: .continuous, interGroupSpacing: 0,
            supplementaryItems: [supplementaryHeaderItem()], contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 0)
        return section
    }
    
    // Header
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
}

//MARK: - UICollectionViewDelegate

extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .popular(_):
            let recipe = sections[indexPath.section].recipes[indexPath.row]
            let detailVC = DetailViewController(recipeModel: recipe)
            self.navigationController?
                .pushViewController(detailVC, animated: true)
            detailVC.configure(id: recipe.id)
        case .category(_):
            let category = categoryRescipes[indexPath.row]
            dataManager?.fetchRecipe(category: category, sort: .random,
                                     number: 20, completion: { result in
                switch result {
                case .success(let recipes):
                    let categoryVC = CategoriesListViewController(
                        model: recipes, recipeImage: nil, title: category.title)
                    DispatchQueue.main.async {
                        self.navigationController?
                            .pushViewController(categoryVC, animated: true)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            })
            
        case .random(_):
            let recipe = sections[indexPath.section].recipes[indexPath.row]
            let detailVC = DetailViewController(recipeModel: recipe)
            self.navigationController?
                .pushViewController(detailVC, animated: true)
            detailVC.configure(id: recipe.id)
        }
    }
}

//MARK: - IUCollectionViewDataSource

extension RecipesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch sections[indexPath.section] {
            case .popular(let popular):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PopularCollectionViewCell.identifier,
                    for: indexPath) as? PopularCollectionViewCell else {
                    return UICollectionViewCell()
                }
                dataManager?.fetchImage(id: popularRecipes[indexPath.row].id,
                                        size: .size556x370) { image in
                    DispatchQueue.main.async {
                        cell.addImageToCell(image: image)
                    }
                }
                cell.configureCell(model: popular[indexPath.row])
                return cell
                
            case .category(let category):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCollectionViewCell.identifier,
                    for: indexPath) as? CategoryCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(categoryName: category[indexPath.row].title,
                                   imageName: category[indexPath.row].image  ?? "" )
                return cell
                
            case .random(let random):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RandomCollectionViewCell.identifier,
                    for: indexPath) as? RandomCollectionViewCell
                else {
                    return UICollectionViewCell()
                }
                dataManager?.fetchImage(id: randomRecipes[indexPath.row].id,
                                        size: .size636x393) { image in
                    DispatchQueue.main.async {
                        cell.addImageToCell(image: image)
                    }
                }
                cell.configureCell(recipe: random[indexPath.row])
                return cell
            }
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView",
                for: indexPath) as? HeaderSupplementaryView else {
                return UICollectionReusableView()
            }
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
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
