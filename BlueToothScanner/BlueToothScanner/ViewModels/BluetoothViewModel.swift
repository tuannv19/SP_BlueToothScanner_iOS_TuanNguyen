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
        return self.peripherals.count
    }
    var peripherals: [PeripheralModel] = [] {
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
    private var peripheralInfos = [PeripheralInfo]()
    
    var fillterModel = FilterModel()
}

extension BluetoothViewModel{
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
            //bluetooth distance
            //            if let power = peripheralInfo.1[CBAdvertisementDataTxPowerLevelKey] as? Double{
            //                print("Distance is ", pow(10, ((power - Double(truncating: peripheralInfo.2))/20)))
            //            }
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
        
        //check if Peripheral had existing
        guard let indexOfExistPeripheral = self.peripheralInfos
            .firstIndex(where: { (model: PeripheralInfo) -> Bool in
                model.0.identifier.uuidString == peripheralInfo.0.identifier.uuidString
            }) as Int? else{
                
                //if not exit just add and update UI
                self.peripheralInfos.append(peripheralInfo)
                return
        }
        
        //update peripheral data
        // RSSI
        self.peripheralInfos[indexOfExistPeripheral].2 = peripheralInfo.2
        
        //fillter data
        self.peripherals = self.applyFilter()
        
    }
    
    func applyFilter() ->  [PeripheralModel] {
        let v = self.peripheralInfos.filter { (peripheralInfo) -> Bool in
            var fromFilter = true
            var toFilter = true
            var nameFilter = true

            if self.fillterModel.fillterRSSI {
                if let rssiFrom = fillterModel.rssiFrom {
                    fromFilter = rssiFrom < peripheralInfo.2.intValue
                }
                
                if let rssiToo = fillterModel.rssiFrom {
                    toFilter = rssiToo > peripheralInfo.2.intValue
                }
            }
            
            if self.fillterModel.fillterEmptyName {
                nameFilter = peripheralInfo.0.name != nil
            }
            
            return fromFilter && toFilter && nameFilter
        }

        return v.compactMap { (info: PeripheralInfo) -> PeripheralModel? in
            var model = PeripheralModel(info: info)
            if(model?.name == nil) {
                model?.name = info.0.identifier.uuidString
            }
            return model
        }
    }
}
