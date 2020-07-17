import UIKit

class ScanDeviceTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: self)

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRSSI: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loaddCell(with peripheralModel: PeripheralModel) {
        lbName.text = peripheralModel.name ?? ""
        lbRSSI.text = peripheralModel.rssi?.stringValue ?? ""
    }
    
}
