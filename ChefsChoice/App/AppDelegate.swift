import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //let dataManager = CoreDataManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
        self.window = window
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        FavoriteViewController().context = context
        
        return true
    }
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        dataManager.saveContext()
//    }

}


