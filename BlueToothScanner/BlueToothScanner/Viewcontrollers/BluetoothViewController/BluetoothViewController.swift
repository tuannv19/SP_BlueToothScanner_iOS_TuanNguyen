import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var swithControll: UISwitch!
    
    
    lazy var viewmodel : BluetoothViewModel = {
        let inputController = BluetoothViewModel.InputControll(
            peripheralTableView: self.tableView,
            swithScanStateController: self.swithControll
        )
        
        let vm  = BluetoothViewModel(input: inputController)
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
    
    func showAlert(title: String, message: String)  {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension BluetoothViewController {
    @IBAction func sliderStartsScanValueChanged(_ sender: UISwitch) {
        self.viewmodel.isScanning = sender.isOn
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
