import CoreBluetooth

public enum BLError: Error {
    public enum BLErrorReason {
        case poweredOff
        case unauthorized
        case resetting
        case unsupported
        case unknown

        var localizedDescription: String {
            switch self {
            case .poweredOff: return "poweredOff"
            case .unauthorized: return "unauthorized"
            case .resetting: return "resetting"
            case .unsupported: return "unsupported"
            case .unknown: return "unknown"
            }
        }
    }
    case bluetoothUnavailable(reason: BLErrorReason)

    var localizedDescription: String {
        switch  self {
        case .bluetoothUnavailable(reason: let reason):
            return reason.localizedDescription
        }
    }
}

class BluetoothService: NSObject {

    public typealias BluetoothStateCallback = (CBManagerState) -> Void
    public typealias BluetoothPeripheralStateCallback = (PeripheralInfo) -> Void
    public typealias BlueToothErrorCallBack = (BLError) -> Void

    static let shared = BluetoothService()

    // MARK: - Private Properties
    private var cbManager: CBCentralManager!

    // MARK: - Closure Properties
    var bluetoothStateCallBack: BluetoothStateCallback?
    var peripheralStateCallback: BluetoothPeripheralStateCallback?

    // MARK: -
    var isScanning: Bool {
        return self.cbManager.isScanning
    }
    var isAuthority: Bool {
        return self.cbManager.state != .unauthorized
    }
    var state: CBManagerState {
        return self.cbManager.state
    }

    // Initialization
    private override init() {
        super.init()

        self.cbManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothService {

    func startScan() {
        self.cbManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScan() {
        if self.cbManager.isScanning {
            self.cbManager.stopScan()
        }
    }
}
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.bluetoothStateCallBack?(central.state)
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        self.peripheralStateCallback?((peripheral, advertisementData, RSSI))
    }
}
