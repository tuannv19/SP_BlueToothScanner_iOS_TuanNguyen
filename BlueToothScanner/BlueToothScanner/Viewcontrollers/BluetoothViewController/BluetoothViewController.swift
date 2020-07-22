import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController, ViewControllerType {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var bluetoothStateLabel: UILabel!
    @IBOutlet weak var bluetoothScanIndicator: UIActivityIndicatorView!
    @IBOutlet weak var totalDeviceLabel: UILabel!

    var viewModel: BluetoothViewModel! = BluetoothViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bluetooth"
        self.setupNavigationBarButton()
        self.bindViewModel()
        self.setupTableView()
        self.viewModel.initialBluetoothService()
    }
    func setupTableView() {
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

    func setupNavigationBarButton() {
        let rightButton = UIBarButtonItem(title: "Filter",
                                          style: .plain,
                                          target: self, action: #selector(rightBarButtonCLick))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    @objc func  rightBarButtonCLick() {
        let viewModel = FilterSettingViewModel(model: self.viewModel.filterModel)
        let vc = FilterSettingViewController.create(viewModel: viewModel)

        vc.viewModel.didSendData = { [weak self] filterMode in
            guard let self = self  else {
                return
            }
            self.viewModel.applyNewFilter(filterModel: filterMode)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}
extension BluetoothViewController {
    func bindViewModel() {
        self.viewModel.bluetoothStateDidChange.bind { [weak self] (state) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                var currentState: String
                switch state {
                case .poweredOff:
                    currentState = "poweredOff"
                    self.switchControl.isEnabled = false
                case .poweredOn:
                    currentState = "poweredOn"
                    self.switchControl.isEnabled = true
                case.unauthorized:
                    currentState = "unauthorized"
                    self.switchControl.isEnabled = false
                default:
                    currentState = "unknown"
                    self.switchControl.isEnabled = false
                }
                self.bluetoothStateLabel.text = currentState
            }
        }

        self.viewModel.peripherals.bind { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.totalDeviceLabel.text = " (number of devices founded:\(self.viewModel.numberOfPeripheralModel))"
            }
        }
        self.viewModel.isScanning.bind { isScanning in
            DispatchQueue.main.async {
                self.switchControl.setOn(isScanning, animated: true)
                if isScanning == true {
                    self.bluetoothScanIndicator.startAnimating()
                    self.bluetoothScanIndicator.isHidden = false
                } else {
                    self.bluetoothScanIndicator.stopAnimating()
                    self.bluetoothScanIndicator.isHidden = true
                }
            }
        }
    }
}

extension BluetoothViewController {
    @IBAction func sliderStartsScanValueChanged(_ sender: UISwitch) {
        self.viewModel.scan(isScanning: sender.isOn)
    }
}

extension BluetoothViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model  = viewModel.peripherals.value[indexPath.row]
        let vc = PeripheralViewController.create(
            viewModel: PeripheralViewModel(peripheralModel: model)
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension BluetoothViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfPeripheralModel
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScanDeviceTableViewCell.reuseIdentifier,
            for: indexPath
            ) as! ScanDeviceTableViewCell

        let model  = viewModel.peripherals.value[indexPath.row]
        cell.nameLabel.text = model.name ?? ""
        cell.rssiLabel.text = model.rssi?.stringValue
        return cell
    }

}
