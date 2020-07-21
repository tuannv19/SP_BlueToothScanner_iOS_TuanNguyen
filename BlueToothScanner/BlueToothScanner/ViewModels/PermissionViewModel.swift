import Foundation

class PermissionViewModel {

    func verifyAndprocessNextScreen(completion: ((BLError?) -> Void)?) {
        switch BluetoothService.shared.state {
        case .poweredOn:
            completion?(nil)
        case .poweredOff:
            completion?(.bluetoothUnavailable(reason: .poweredOff))
        case.unauthorized:
            completion?(.bluetoothUnavailable(reason: .unauthorized))
        case.resetting:
            completion?(.bluetoothUnavailable(reason: .resetting))
        case.unsupported:
            completion?(.bluetoothUnavailable(reason: .unsupported))
        default:
            completion?(.bluetoothUnavailable(reason: .unknown))
        }
    }

}
