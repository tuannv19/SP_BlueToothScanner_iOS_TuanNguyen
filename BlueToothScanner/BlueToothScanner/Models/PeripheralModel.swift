import Foundation
import CoreBluetooth

//PeripheralInfo = (peripheral, adv data , RSSI)
public typealias PeripheralInfo = (CBPeripheral, [String: Any], NSNumber)

struct PeripheralModel {
    var name: String?
    var identifier: String?//same with UUID
    var rssi: NSNumber?
    var customValue: [String: Any]?

    init?(info: PeripheralInfo) {

        self.name = info.0.name
        self.identifier = info.0.identifier.uuidString
        self.rssi = info.2
        self.customValue = info.1
    }

    func prettyString() -> String {
        let info: [String]? = self.customValue?.map { return ("\($0): \($1)") }
        let infoString = info?.joined(separator: "\n")

        return """
        name: \(self.name ?? "")
        UUID: \(self.identifier!)
        RSSI: \(String(describing: self.rssi))
        info: \(infoString ?? "")
        """
    }
}
