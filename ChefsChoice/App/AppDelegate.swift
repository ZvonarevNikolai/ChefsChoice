import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dataManager = CoreDataManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = UserDefaults.standard.bool(forKey: "isFirst") ? MainTabBarController() : OnboardingViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navVC
        window.backgroundColor = .black
        window.makeKeyAndVisible()
        self.window = window
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        FavoriteViewController().context = context
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataManager.saveContext()
    }
    
    
}


