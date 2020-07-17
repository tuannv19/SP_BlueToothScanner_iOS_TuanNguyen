import  CoreBluetooth

class BluetoothViewModel{
    
    //MARK: - Private Properties
    private var isScanning: Bool = false {
        didSet {
            self.bluetoothScanStateDidChange?(isScanning)
        }
    }
    
    private var bluetoothState : CBManagerState = .unknown {
        didSet {
            self.bluetoothStateDidChange?(bluetoothState)
            if(bluetoothState != .poweredOn && isScanning == true) {
                // stop all services
                self.stopScan()
                self.isScanning = false
            }
        }
    }
    
    //MARK: - Public Properties
    var numbrOfPeripheralModel: Int {
        return self.listPeripheral.count
    }
    var listPeripheral: [PeripheralModel] = [] {
        didSet {
            self.reloadTableview?()
        }
    }

    //MARK: - Clousure Properties
    var reloadTableview:(()->())?
    var bluetoothScanStateDidChange: ((Bool)->())?
    var bluetoothStateDidChange: ((CBManagerState)->())?
    
    //MARK: - Bluetooth
    private let bluetoothService = BluetoothService.shared
    
    func initialBluetoothService() {
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
    func scan(isScanning: Bool) {
        self.isScanning = isScanning
        if isScanning {
            self.startScan()
        }else {
            self.stopScan()
        }
    }
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
