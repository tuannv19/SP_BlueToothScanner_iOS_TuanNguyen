import UIKit
import RxSwift
import RxCocoa

class PermissionsViewController: UIViewController, ViewControllerType {
    var viewModel: PermissionViewModel!
    let disposeBag = DisposeBag()
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "BlueToothScanner"
        self.viewModel = PermissionViewModel()
        self.bind()
    }
    func bind() {
        let input = PermissionViewModel.Input(
            continueButtonTrigger: self.continueButton.rx.tap.asObservable()
        )
        let output = self.viewModel.transform(input: input)
        
        output.perFormNextScreen.drive(onNext: { [unowned self] _ in
            self.moveToTabBarController()
        }).disposed(by: self.disposeBag)
        
        output.errorDidOccur.drive(onNext: { [unowned self] error in
            self.showAlert(
                title: "Error",
                message: error.localizedDescription,
                style: .alert,
                actions: [AlertAction(title: "Close", style: .cancel)]
            ).asDriver(onErrorJustReturn: 99)
                .drive()
                .disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
    }
    func moveToTabBarController() {
        let vc = Self.createTabBar()
        guard let  keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        keyWindow.rootViewController = vc
        keyWindow.makeKeyAndVisible()
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
