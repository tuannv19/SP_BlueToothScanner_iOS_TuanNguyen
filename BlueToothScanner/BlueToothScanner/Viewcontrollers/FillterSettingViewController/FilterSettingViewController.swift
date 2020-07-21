import UIKit

class FilterSettingViewController: UIViewController {
    @IBOutlet weak var rssiFromTextField: UITextField!
    @IBOutlet weak var rssiToTextField: UITextField!
    @IBOutlet weak var rssiSwitchControl: UISwitch!
    @IBOutlet weak var emptyDeviceNameSwitchControl: UISwitch!

    var viewModel: FilterSettingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.rssiToTextField.delegate = self
        self.rssiFromTextField.delegate = self

        self.bindViewModel()
    }

    func bindViewModel() {

        if let from = viewModel.filterModel.rssiFrom {
            self.rssiFromTextField.text = "\(from)"
        }
        if let to = viewModel.filterModel.rssiTo {
            self.rssiToTextField.text = "\(to)"
        }

        self.rssiSwitchControl.isOn = viewModel.filterModel.filterRSSI
        self.emptyDeviceNameSwitchControl.isOn = viewModel.filterModel.filterEmptyName
    }

    @IBAction func applyButtonDidclick(_ sender: Any) {
        self.viewModel?
            .verifyBluetoothState(
                fromRSSI: Int( self.rssiFromTextField.text!) ?? nil,
                                  toRSSI: Int(self.rssiToTextField.text!) ?? nil,
                                  filterRSSI: self.rssiSwitchControl.isOn,
                                  filterEmptyName: self.emptyDeviceNameSwitchControl.isOn
            ) { [ unowned self] (model, error) in
                if let  model = model {
                    self.viewModel?.didSendData?(model)
                    self.dismissAndCLoseKeyboard()
                }

                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self.dismissAndCLoseKeyboard()
        }

    }
    @IBAction func closeButtonDidClick(_ sender: Any) {
        self.dismissAndCLoseKeyboard()
    }
    func dismissAndCLoseKeyboard() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

}

extension FilterSettingViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return viewModel.shouldChangeCharactersIn(currentText: textField.text!,
                                                  range: range,
                                                  replacementString: string)
    }
}

// MARK: - Factory
extension FilterSettingViewController {
    static func create(viewModel: FilterSettingViewModel) -> FilterSettingViewController {

        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "FilterSettingViewController"
            ) as! FilterSettingViewController
        vc.viewModel = viewModel

        return vc
    }
}
