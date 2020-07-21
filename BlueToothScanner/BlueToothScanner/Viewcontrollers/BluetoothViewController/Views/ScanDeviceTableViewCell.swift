import UIKit

class ScanDeviceTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: self)

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!

}
