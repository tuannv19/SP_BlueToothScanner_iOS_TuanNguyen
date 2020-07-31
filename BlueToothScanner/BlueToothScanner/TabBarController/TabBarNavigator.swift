import UIKit

class TabBarNavigator: Coordinator {
    typealias Router = TabBarRouter
    
    enum TabBarRouter{
        case initial
    }
    
    var navigationController: UINavigationController?
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func routed(router: TabBarRouter) {
        let vc = PermissionsNavigator(nav: UINavigationController())
        window.rootViewController = vc.navigationController
        vc.routed(router: .initial)
        window.makeKeyAndVisible()
    }
}
