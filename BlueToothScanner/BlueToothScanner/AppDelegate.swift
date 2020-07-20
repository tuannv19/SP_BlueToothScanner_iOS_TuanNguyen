import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let permissionViewController = PermissionsViewController.Create()
        self.window?.rootViewController = permissionViewController
        self.window?.makeKeyAndVisible()

        return true
    }


}

