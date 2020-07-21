import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchControll: UISwitch!
    @IBOutlet weak var bluetoothStateLabel: UILabel!
    @IBOutlet weak var bluetoothScanIndicator: UIActivityIndicatorView!
    @IBOutlet weak var totalDeviceLabel: UILabel!

    lazy var viewmodel: BluetoothViewModel = {
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
                self.totalDeviceLabel.text = " (number of devices founded:\(self.viewmodel.numbrOfPeripheralModel))"
            }
        }

        vm.bluetoothScanStateDidChange = { [unowned self] isScanning in
            DispatchQueue.main.async {
                self.switchControll.setOn(isScanning, animated: true)
                if isScanning == true {
                    self.bluetoothScanIndicator.startAnimating()
                    self.bluetoothScanIndicator.isHidden = false
                } else {
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

        self.title = "Bluetooth"
        self.setupNavigationBarButton()
        self.setupTableView()
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
        let rightBtn = UIBarButtonItem(title: "Filter",
                                       style: .plain,
                                       target: self, action: #selector(rightBarButtonCLick))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    @objc func  rightBarButtonCLick() {
        let viewModel = FillterSettingViewModel(model: self.viewmodel.fillterModel)
        let vc = FilterSettingViewController.create(viewModel: viewModel)

        vc.viewModel?.didSendData = { [weak self] filterMode in
            guard let self = self  else {
                return
            }
            self.viewmodel.applyNewFilter(fillterModel: filterMode)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }

}

extension BluetoothViewController {
    @IBAction func sliderStartsScanValueChanged(_ sender: UISwitch) {
        self.viewmodel.scan(isScanning: sender.isOn)
    }
}

extension BluetoothViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let model  = viewmodel.peripherals[indexPath.row]
        let vc = PeripheralViewController.create(peripheral: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension BluetoothViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.numbrOfPeripheralModel
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScanDeviceTableViewCell.reuseIdentifier,
            for: indexPath
            ) as! ScanDeviceTableViewCell

        let model  = viewmodel.peripherals[indexPath.row]
        cell.lbName.text = model.name ?? ""
        cell.lbRSSI.text = model.rssi?.stringValue
        return cell
    }

}

// MARK: - Factory
extension BluetoothViewController {
    static func create() -> BluetoothViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "BluetoothViewController"
            ) as! BluetoothViewController
        return vc
    }
}
