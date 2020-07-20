import UIKit

class PermissionsViewController: UIViewController {
    var viewModel: PermissionViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel = PermissionViewModel()
    }
    
    @IBAction func continueButtonDidClick(_ sender: Any) {
        self.viewModel?.verifyAndprocessNextScreen(completion: { (error) in
            guard let error = error else {
                let vc = BluetoothViewController.Create()
                UIApplication.shared.keyWindow?.rootViewController = vc
                UIApplication.shared.keyWindow?.makeKeyAndVisible()

                return
            }
            
            self.showAlert(title: "Error", message: error.localizedDescription)
        })
    }
}

//MARK: - Factory
extension PermissionsViewController {
    static func Create()-> PermissionsViewController {
        let vm = PermissionViewModel()
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "PermissionsViewController"
            ) as! PermissionsViewController
        vc.viewModel = vm
        return vc
    }
}