import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchControll: UISwitch!
    @IBOutlet weak var bluetoothStateLabel: UILabel!
    @IBOutlet weak var bluetoothScanIndicator: UIActivityIndicatorView!
    
    
    lazy var viewmodel : BluetoothViewModel = {
        let vm  = BluetoothViewModel()
        
        vm.bluetoothStateDidChange = { [unowned self] state in
            var currentState: String
            switch state {
            case .poweredOff:
                currentState = "poweredOff"
                self.switchControll.isEnabled = false
            case .poweredOn:
                currentState = "poweredOn"
                self.switchControll.isEnabled = true
            case.unauthorized:
                currentState = "unauthorized"
                self.switchControll.isEnabled = false
            default:
                currentState = "unknow"
                self.switchControll.isEnabled = false
            }
            self.bluetoothStateLabel.text = currentState
        }
        
        vm.reloadTableview = { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        vm.bluetoothScanStateDidChange = { [unowned self] state in
            DispatchQueue.main.async {
                self.switchControll.setOn(state, animated: true)
            }
        }
        
        vm.initialBluetoothService()
        
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        
        self.tableView.register(
            UINib(nibName: "ScanDeviceTableViewCell", bundle: nil),
            forCellReuseIdentifier: ScanDeviceTableViewCell.reuseIdentifier
        )
        self.tableView.reloadData()
    }
}

extension BluetoothViewController {
    @IBAction func sliderStartsScanValueChanged(_ sender: UISwitch) {
        self.viewmodel.scan(isScanning: sender.isOn)
    }
}

extension BluetoothViewController: UITableViewDelegate{
    
}
extension BluetoothViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.numbrOfPeripheralModel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScanDeviceTableViewCell.reuseIdentifier,
            for: indexPath
            ) as! ScanDeviceTableViewCell
        
        let model  = viewmodel.listPeripheral[indexPath.row]
        cell.loaddCell(with: model)
        return cell
        
    }
    
}
