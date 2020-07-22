import  CoreBluetooth

class BluetoothViewModel {

    // MARK: - Private Properties

    private var bluetoothState: CBManagerState = .unknown {
        didSet {
            bluetoothStateDidChange.value = bluetoothState
            if bluetoothState != .poweredOn && isScanning.value == true {
                // stop all services
                self.stopScan()
                self.isScanning.value = false
            }
        }
    }

    // MARK: - Public Properties
    var numberOfPeripheralModel: Int {
        return self.peripherals.value.count
    }

    // MARK: - Dynamic Properties
    var peripherals = Dynamic<[PeripheralModel]>([])
    var isScanning  = Dynamic<Bool>(false)
    var bluetoothStateDidChange = Dynamic<CBManagerState>(.unknown)

    // MARK: - Bluetooth
    private let bluetoothService = BluetoothService.shared
    private var peripheralInfos = [PeripheralInfo]()

    var filterModel = FilterModel()
}

extension BluetoothViewModel {
    func initialBluetoothService() {
        self.isScanning.value = self.bluetoothService.isScanning
        self.registerBluetoothServicesCallback()
        self.bluetoothState = self.bluetoothService.state
    }

    private func registerBluetoothServicesCallback() {

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

extension BluetoothViewModel {
    func scan(isScanning: Bool) {
        self.isScanning.value = isScanning
        if isScanning {
            self.startScan()
        } else {
            self.stopScan()
        }
    }
    func startScan() {
        self.bluetoothService.startScan()
    }

    func stopScan() {
        self.bluetoothService.stopScan()
    }

    func applyNewFilter(filterModel: FilterModel) {
        self.filterModel = filterModel
        self.peripherals.value = self.applyFilter()
    }

    internal func addOrUpdatePeripheralIfNeed(peripheralInfo: PeripheralInfo) {

        //check if Peripheral had existing
        guard let indexOfExistPeripheral = self.peripheralInfos
            .firstIndex(where: { (model: PeripheralInfo) -> Bool in
                model.0.identifier.uuidString == peripheralInfo.0.identifier.uuidString
            }) as Int? else {

                //if not exit just add and update UI
                self.peripheralInfos.append(peripheralInfo)
                return
        }

        //update peripheral data
        // RSSI
        self.peripheralInfos[indexOfExistPeripheral].2 = peripheralInfo.2

        //filter data
        self.peripherals.value = self.applyFilter()

    }

    internal func applyFilter() -> [PeripheralModel] {
        let v = self.peripheralInfos.filter { (peripheralInfo) -> Bool in
            if self.filterModel.filterEmptyName {
                guard peripheralInfo.0.name != nil else {
                    return false
                }
            }
            if self.filterModel.filterRSSI {
                if let rssiFrom = filterModel.rssiFrom {
                    guard rssiFrom < peripheralInfo.2.intValue else {
                        return false
                    }
                }
                if let rssiToo = filterModel.rssiTo {
                    guard rssiToo > peripheralInfo.2.intValue else {
                        return false
                    }
                }
            }
            return true
        }

        return v.compactMap { (info: PeripheralInfo) -> PeripheralModel? in
            var model = PeripheralModel(info: info)
            if model?.name == nil {
                model?.name = info.0.identifier.uuidString
            }
            return model
        }
    }
}
