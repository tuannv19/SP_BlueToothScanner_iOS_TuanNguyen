import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class BluetoothViewController: UIViewController, Storyboarded, ViewControllerType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var bluetoothStateLabel: UILabel!
    @IBOutlet weak var scanDeviceIndicator: UIActivityIndicatorView!
    @IBOutlet weak var totalDeviceLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var viewModel: BluetoothViewModel! = BluetoothViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Bluetooth"
        scanDeviceIndicator.hidesWhenStopped = true
        self.setupTableView()
        self.bindViewModel()
    }
    
    func bindViewModel() {
        let input = BluetoothViewModel.Input(
            isScanning: self.switchControl.rx.isOn.asObservable(),
            itemSelected: self.tableView.rx.itemSelected.asObservable()
        )
        let output = self.viewModel.transform(input: input)
        output.bluetoothState
            .drive(self.bluetoothStateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.isEnableSwitchButton
            .debug()
            .drive(switchControl.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        output.isScanning
            .drive(scanDeviceIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        output.peripherals
            .drive(
                self.tableView.rx.items(
                    cellIdentifier: ScanDeviceTableViewCell.reuseIdentifier,
                    cellType: ScanDeviceTableViewCell.self
                )
            ){row, element, cell in
                cell.nameLabel.text = element.name
                cell.rssiLabel.text = element.rssi?.stringValue
        }.disposed(by: self.disposeBag)

    }
    func setupTableView() {
        //remove empty table cell
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(
            UINib(nibName: "ScanDeviceTableViewCell", bundle: nil),
            forCellReuseIdentifier: ScanDeviceTableViewCell.reuseIdentifier
        )
    }
    
    func setupNavigationBarButton() {
        let rightButton = UIBarButtonItem(title: "Filter",
                                          style: .plain,
                                          target: self, action: #selector(rightBarButtonCLick))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    @objc func  rightBarButtonCLick() {
    }
}
