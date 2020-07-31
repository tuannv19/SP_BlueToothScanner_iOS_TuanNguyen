import UIKit

class PermissionsNavigator: Coordinator {
    var navigationController: UINavigationController?
    
    enum Router {
        case initial
        case tabBar
    }

    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func routed(router: Router) {
        switch router {
        case .tabBar:
            let tabBar = BluetoothCoordinator(nav: self.navigationController!)
            tabBar.routed(router: .initial)
        case .initial:
            let vc = PermissionsViewController.instantiate()
            let vm = PermissionViewModel(navigator: self)
            vc.viewModel = vm
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
