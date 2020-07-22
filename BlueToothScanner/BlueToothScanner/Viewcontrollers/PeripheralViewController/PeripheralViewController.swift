import UIKit

class PeripheralViewController: UIViewController, ViewControllerType {
    @IBOutlet weak var infoTextView: UITextView!
    var viewModel: PeripheralViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let vm = self.viewModel {
            self.infoTextView.text = vm.peripheralModel?.prettyString()
            self.title = vm.peripheralModel?.name
        }

    }
}
