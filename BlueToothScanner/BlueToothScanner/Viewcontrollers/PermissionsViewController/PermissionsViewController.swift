import UIKit

class PermissionsViewController: UIViewController {
    var viewModel: PermissionViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "BlueToothScanner"

        self.viewModel = PermissionViewModel()

    }

    @IBAction func continueButtonDidClick(_ sender: Any) {
        self.viewModel?.verifyAndprocessNextScreen(completion: { (error) in
            guard let error = error else {
                let vc = Self.createTabbar()
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
    static func create() -> PermissionsViewController {
        let vm = PermissionViewModel()

        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "TabbarController"
            ) as! PermissionsViewController
        vc.viewModel = vm
        return vc
    }
    static func createTabbar() -> UITabBarController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "TabbarController"
            ) as! UITabBarController
        return vc
    }
}
