import UIKit

class FilterSettingViewController: UIViewController {
    @IBOutlet weak var rssiFromTextField: UITextField!
    @IBOutlet weak var rssiToTextField: UITextField!
    @IBOutlet weak var rssiSwitchControll: UISwitch!
    @IBOutlet weak var emptyDeviceNameSwitchControll: UISwitch!
    internal static let MaxNumCharacters = 5
    
    var viewModel : FillterSettingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.rssiToTextField.delegate = self
        self.rssiFromTextField.delegate = self
        
        
        if let from = viewModel.filterModel.rssiFrom {
            self.rssiFromTextField.text = "\(from)"
        }
        if let to = viewModel.filterModel.rssiTo {
            self.rssiToTextField.text = "\(to)"
        }
        
        self.rssiSwitchControll.isOn = viewModel.filterModel.fillterRSSI
        self.emptyDeviceNameSwitchControll.isOn = viewModel.filterModel.fillterEmptyName
    }
    
    @IBAction func applyButtonDidclick(_ sender: Any) {
        self.viewModel?
            .verifyBluetoothState(fromRSSI: Int( self.rssiFromTextField.text!) ?? nil,
                                  toRSSI: Int(self.rssiToTextField.text!) ?? nil,
                                  fillterRSSI: self.rssiSwitchControll.isOn,
                                  fillterEmptyName: self.emptyDeviceNameSwitchControll.isOn
            ) { [ weak self] (model, error) in
                guard let self  = self else {
                    return
                }
                if let  model = model {
                    self.viewModel?.didSendData?(model)
                    self.dismissAndCLoseKeyboad()
                }
                
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self.dismissAndCLoseKeyboad()
        }
        
    }
    @IBAction func closeButtonDidClick(_ sender: Any) {
        self.dismissAndCLoseKeyboad()
    }
    func dismissAndCLoseKeyboad(){
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
        
        let newLength = textField.text!.count + string.count - range.length
        if (newLength >= Self.MaxNumCharacters){
            return false
        }
        
        if string == "-", range.location != 0 {
            return false
        }
        
        let allowedCharacters = CharacterSet(charactersIn:"-0123456789 ")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

//MARK: - Factory
extension FilterSettingViewController {
    static func Create(viewModel: FillterSettingViewModel)-> FilterSettingViewController {
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "FillterSettingViewController"
            ) as! FilterSettingViewController
        vc.viewModel = viewModel
        
        return vc
    }
}
