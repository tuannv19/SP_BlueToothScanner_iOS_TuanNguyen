import UIKit

class PeripheralViewController: UIViewController {
    @IBOutlet weak var infoTextView: UITextView!
    var viewModel: PeripheralViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let vm = viewModel {
            self.infoTextView.text = vm.peripheralModel?.prettyString()
            self.title = vm.peripheralModel?.name
        }

    }
}

// MARK: - Factory
extension PeripheralViewController {
    static func create(peripheral: PeripheralModel) -> PeripheralViewController {
        let vm = PeripheralViewModel(peripheralModel: peripheral)

        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "PeripheralViewController"
            ) as! PeripheralViewController
        vc.viewModel = vm
        return vc
    }
}
