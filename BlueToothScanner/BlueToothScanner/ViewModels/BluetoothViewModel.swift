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
            self.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfo)
        }
    }
}
extension BluetoothViewModel{
    func startScan() {
        self.bluetoothService.startScan()
    }
    
    func stopScan() {
        self.bluetoothService.stopScan()
    }
    func addOrUpdatePeripheralIfNeed(peripheralInfo: PeripheralInfo) {
        
        guard let peripheralModel = PeripheralModel(info: peripheralInfo) else {
            return
        }
        
        //check if Peripheral had existing
        guard let indexOfExistModel = self.listPeripheral
            .firstIndex(where: { (model: PeripheralModel) -> Bool in
                model.identifier == peripheralInfo.0.identifier.uuidString
            }) as Int? else{

                //if not exit just add and update UI
                self.listPeripheral.append(peripheralModel)
                return
        }

        //update RSSI number is enough
        self.listPeripheral[indexOfExistModel].rssi = peripheralInfo.2
        
    }
}
