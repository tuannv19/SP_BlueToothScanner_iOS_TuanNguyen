import  CoreBluetooth

class BluetoothViewModel{
    
    typealias Peripheral = (CBPeripheral, [String : Any], NSNumber)
    //MARK: - Properties
    var listPeripheral: [Peripheral] = [] {
        didSet {
        }
    }
    var bluetoothState : CBManagerState = .unknown {
        didSet {
            print("State2: \(bluetoothState.rawValue)")
        }
    }
    //MARK: - Bluetooth
    private let bluetoothService = BluetoothService.shared
    
    init() {
        self.bluetoothService.bluetoothStateCallBack = { [weak self] state in
            guard let self = self else {
                return
            }
            self.bluetoothState = state
        }
    }
}


class BluetoothService : NSObject {
    
    public typealias BluetoothStateCallback = (CBManagerState) -> Void
    public typealias BluetoothPeripheralStateCallback = (CBPeripheral, [String : Any], NSNumber) -> Void
    public typealias BlueToothErrorCallBack = (BLEError)-> Void
    
    public enum BLEError : Error {
        case unauthority
        var localizedDescription : String {
            switch self {
            case .unauthority:
                return "unauthority"
            }
        }
    }
    
    // MARK: - Private Properties
    private var cbManager: CBCentralManager!
    
    // MARK: - Public Properties
    static let shared = BluetoothService()

    var bluetoothStateCallBack : BluetoothStateCallback?
    var peripheralStateCallback : BluetoothPeripheralStateCallback?
    
    var isScanning: Bool {
        return self.cbManager.isScanning
    }
    var isAuthority: Bool {
        return self.cbManager.state != .unauthorized
    }
    
    // Initialization
    private override init() {
        super.init()
        
        self.cbManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // Main funtion
    func startScan() {
        self.cbManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        self.cbManager.stopScan()
    }
    
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.bluetoothStateCallBack?(central.state)
        switch central.state {
        case .poweredOn:
            self.startScan()
        default: break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheralStateCallback?(peripheral, advertisementData, RSSI)
        print(peripheral.name)
    }
}
