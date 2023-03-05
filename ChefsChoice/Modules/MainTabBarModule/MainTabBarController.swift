import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureMainTabBar()
    }
    
    private func configureMainTabBar() {
        let recipesVC = createNavigationVC(
            rootVC: RecipesViewController(),
            title: "Chef's Choise", imageSystemName: "swift")
        let searchVC = createNavigationVC(
            rootVC: SearchVC(), title: "Search", imageSystemName: "search")
        viewControllers = [recipesVC, searchVC]
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
            return navVC
        }
}

