import UIKit

class ScanDeviceTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: self)

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRSSI: UILabel!
    
}
