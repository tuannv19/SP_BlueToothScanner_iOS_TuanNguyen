import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var swithControll: UISwitch!
    @IBOutlet weak var bluetoothStateLabel: UILabel!
    
    lazy var viewmodel : BluetoothViewModel = {
        let vm  = BluetoothViewModel()
        vm.bluetoothStateDidChange = { [unowned self] state in
            var currentState: String
            switch state {
            case .poweredOff:
                currentState = "poweredOff"
            case .poweredOn:
                currentState = "poweredOn"
            case.unauthorized:
                currentState = "unauthorized"
            default:
                currentState = "unknow"
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
                self.swithControll.setOn(state, animated: true)
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
            UINib(nibName: "ScanDeviceHeaderView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "ScanDeviceHeaderView"
        )
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "ScanDeviceHeaderView"
            ) as! ScanDeviceHeaderView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
}
