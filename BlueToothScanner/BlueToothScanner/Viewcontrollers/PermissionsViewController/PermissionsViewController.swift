import UIKit
import RxSwift
import RxCocoa

class PermissionsViewController: UIViewController, Storyboarded {
    var viewModel: PermissionViewModel!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "BlueToothScanner"
        self.bind()
    }
    func bind() {
        let input = PermissionViewModel.Input(
            continueButtonTrigger: self.continueButton.rx.controlEvent(.touchUpInside).asObservable()
        )
        let output = self.viewModel.transform(input: input)
    
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
}
