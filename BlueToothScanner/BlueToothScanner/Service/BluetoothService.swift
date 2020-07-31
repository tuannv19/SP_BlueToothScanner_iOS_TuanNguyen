import CoreBluetooth
import RxSwift

public enum BLError: Error, Equatable {
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

//    public typealias BluetoothStateCallback = (CBManagerState) -> Void
//    public typealias BluetoothPeripheralStateCallback = (PeripheralInfo) -> Void
//    public typealias BlueToothErrorCallBack = (BLError) -> Void

    static let shared = BluetoothService()

    // MARK: - Private Properties
    var cbManager: CBCentralManager!

    // MARK: - Closure Properties
    var bluetoothStateDidReceive = PublishSubject<CBManagerState>()
    var peripheralsDidReceive = PublishSubject<PeripheralInfo>()

    // MARK: -
    var isScanning :Observable<Bool> {
        return Observable.just(self.cbManager.isScanning)
    }
    var isAuthority: Observable<Bool> {
        return Observable.just(self.cbManager.state != .unauthorized)
    }

    var state: Observable<CBManagerState> {
        return Observable.just(self.cbManager.state)
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
        self.cbManager.stopScan()
    }
}
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.bluetoothStateDidReceive.onNext(central.state)
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        self.peripheralsDidReceive.onNext((peripheral, advertisementData, RSSI))
    }
}
