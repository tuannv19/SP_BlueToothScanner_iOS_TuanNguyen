import UIKit

class PermissionsViewController: UIViewController, ViewControllerType {
    var viewModel: PermissionViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "BlueToothScanner"

        self.viewModel = PermissionViewModel()

    }

    @IBAction func continueButtonDidClick(_ sender: Any) {
        self.viewModel.verifyAndProcessNextScreen(completion: { (error) in
            guard let error = error else {
                let vc = Self.createTabBar()
                UIApplication.shared.keyWindow?.rootViewController = vc
                UIApplication.shared.keyWindow?.makeKeyAndVisible()

                return
            }

            self.showAlert(title: "Error", message: error.localizedDescription)
        })
    }
}

// MARK: - Factory
extension PermissionsViewController {
    static func createTabBar() -> UITabBarController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "TabbarController"
            ) as! UITabBarController
        return vc
    }
}
