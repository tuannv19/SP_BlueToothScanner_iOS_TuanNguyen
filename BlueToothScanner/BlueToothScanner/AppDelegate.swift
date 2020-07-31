import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        _ = BluetoothService.shared

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = TabBarNavigator(window: self.window!)
        coordinator.routed(router: .initial)

        return true
    }

}
