import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureMainTabBar()
    }
    
    private func configureMainTabBar() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .black
        
        let recipesVC = createNavigationVC(
            rootVC: RecipesViewController(),
            title: "Chef's Choise", imageSystemName: "frying.pan")

        let favoriteVC = createNavigationVC(
            rootVC: FavoriteViewController(),
            title: "Favorite",
            imageSystemName: "star.fill")

        let searchVC = createNavigationVC(
            rootVC: SearchVC(), title: "Search", imageSystemName: "magnifyingglass")
        viewControllers = [recipesVC, searchVC, favoriteVC]

    }
    
    private func createNavigationVC(
        rootVC: UIViewController, title: String,
        imageSystemName: String) -> UINavigationController {
            rootVC.navigationItem.largeTitleDisplayMode = .automatic
            let navVC = UINavigationController(rootViewController: rootVC)
            navVC.tabBarItem.title = title
            navVC.title = title
            navVC.tabBarItem.image = UIImage(systemName: imageSystemName, withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            navVC.navigationBar.prefersLargeTitles = true
            navVC.navigationBar.tintColor = .label
            return navVC
        }
}

