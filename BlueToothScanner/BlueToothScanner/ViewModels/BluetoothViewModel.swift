import  CoreBluetooth
import  UIKit

class BluetoothViewModel{
    
    struct InputControll {
        var peripheralTableView: UITableView
        var swithScanStateController: UISwitch
    }
    
    //MARK: - Properties
    var input : InputControll!
    var isScanning: Bool = false {
        didSet {
            if(isScanning){
                self.startScan()
            }else{
                self.stopScan()
            }
            DispatchQueue.main.async {
                self.input.swithScanStateController.setOn(self.isScanning, animated: true)
            }
        }
    }
    
    var listPeripheral: [PeripheralModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.input.peripheralTableView.reloadData()
            }
        }
    }
    
    var numbrOfPeripheralModel: Int {
        return self.listPeripheral.count
    }
    
    var bluetoothState : CBManagerState = .unknown {
        didSet {
            print("State2: \(bluetoothState.rawValue)")
        }
    }
    //MARK: - Bluetooth
    private let bluetoothService = BluetoothService.shared
    
    
    init(input: InputControll) {
        self.input = input
        self.isScanning = self.bluetoothService.isScanning
        self.registerBluetoothServicesCallback()
    }
    
    func startScan() {
        self.bluetoothService.startScan()
    }
    
    func stopScan() {
        self.bluetoothService.stopScan()
    }
    
    private func registerBluetoothServicesCallback(){
        
        self.bluetoothService.bluetoothStateCallBack = { [weak self] state in
            guard let self = self else {
                return
            }
            self.bluetoothState = state
        }
        
        self.bluetoothService.peripheralStateCallback = { [weak self] peripheralInfo in
            guard let self = self else {
                return
            }
            if let peripheralModel = PeripheralModel(info: peripheralInfo) {
                self.listPeripheral.append(peripheralModel)
            }
        }
    }
}
