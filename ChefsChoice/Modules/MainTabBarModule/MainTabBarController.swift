import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func createNavigationVC(rootVC: UIViewController,
                                    title: String,
                                    imageSystemName: String) -> UINavigationController {
        rootVC.navigationItem.largeTitleDisplayMode = .automatic
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = UIImage(
            systemName: imageSystemName,
            withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        return navVC
    }
}

