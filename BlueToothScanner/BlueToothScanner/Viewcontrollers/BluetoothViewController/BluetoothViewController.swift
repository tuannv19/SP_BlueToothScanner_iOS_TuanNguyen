import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchControll: UISwitch!
    @IBOutlet weak var bluetoothStateLabel: UILabel!
    @IBOutlet weak var bluetoothScanIndicator: UIActivityIndicatorView!
    @IBOutlet weak var totalDeviceLabel: UILabel!
    
    
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
                self.totalDeviceLabel.text = " (number of devices:\(self.viewmodel.numbrOfPeripheralModel))"
            }
        }
        
        vm.bluetoothScanStateDidChange = { [unowned self] isScanning in
            DispatchQueue.main.async {
                self.switchControll.setOn(isScanning, animated: true)
                if isScanning == true {
                    self.bluetoothScanIndicator.startAnimating()
                    self.bluetoothScanIndicator.isHidden = false
                }else {
                    self.bluetoothScanIndicator.stopAnimating()
                    self.bluetoothScanIndicator.isHidden = true
                }
            }
        }
        
        vm.initialBluetoothService()
        
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        
        //remove empty table cell
        self.tableView.tableFooterView = UIView()
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model  = viewmodel.listPeripheral[indexPath.row]
        let vc = PeripheralViewController.Create(peripheral: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
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
