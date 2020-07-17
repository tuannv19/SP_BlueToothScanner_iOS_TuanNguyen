import CoreBluetooth

class BluetoothService : NSObject {
    
    public typealias BluetoothStateCallback = (CBManagerState) -> Void
    public typealias BluetoothPeripheralStateCallback = (PeripheralInfo) -> Void
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
        if self.cbManager.isScanning{
            self.cbManager.stopScan()
        }   
    }
}

extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.bluetoothStateCallBack?(central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheralStateCallback?((peripheral, advertisementData, RSSI))
    }
}


