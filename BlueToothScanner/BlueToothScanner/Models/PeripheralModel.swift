import Foundation
import CoreBluetooth

//PeripheralInfo = (peripheral, adv data , RSSI)
public typealias PeripheralInfo = (CBPeripheral, [String : Any], NSNumber)

struct PeripheralModel {
    var name: String?
    var identifier: String?//same with UUID
    var rssi: NSNumber?
    var customeValue : [String: Any]?

    init?(info: PeripheralInfo) {
        guard let name = info.0.name else {
            return nil
        }
        self.name = name
        self.identifier = info.0.identifier.uuidString
        self.rssi = info.2
        self.customeValue = info.1
    }

    func prettyPrint()-> String{
        let infor: [String]? = self.customeValue?.map { return ("\($0): \($1)") }
        let inforString = infor?.joined(separator: "\n")
        
        return """
        name: \(self.name ?? "")
        UUID: \(self.identifier ?? "")
        RSSI: \(String(describing: self.rssi))
        info: \(inforString ?? "")
        """
    }
}
