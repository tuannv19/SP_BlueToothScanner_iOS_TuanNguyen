import Foundation

class FilterSettingViewModel {

    internal static let MaxNumCharacters = 5

    public enum FilterModelError: Error {
        case fromMustLessThanTo
        var localizedDescription: String {
            return "fromMustLessThanTo"
        }
    }

    var didSendData: ((FilterModel) -> Void)?

    var filterModel: FilterModel!

    init(model: FilterModel) {
        self.filterModel = model
    }

    func verifyBluetoothState(fromRSSI: Int?,
                              toRSSI: Int?,
                              filterRSSI: Bool,
                              filterEmptyName: Bool,
                              completion: ((FilterModel?, FilterModelError?) -> Void)?) {

        if let fromRSSI = fromRSSI,
            let toRSSI = toRSSI,
            fromRSSI > toRSSI {
            completion?(nil, .fromMustLessThanTo)
            return
        }

        self.filterModel.rssiFrom = fromRSSI
        self.filterModel.rssiTo = toRSSI
        self.filterModel.filterRSSI = filterRSSI
        self.filterModel.filterEmptyName = filterEmptyName

        completion?(self.filterModel, nil)
    }
    func shouldChangeCharactersIn (currentText: String,
                                   range: NSRange,
                                   replacementString string: String) -> Bool {
        let newLength = currentText.count + string.count - range.length
        if newLength >= Self.MaxNumCharacters {
            return false
        }

        if string == "-", range.location != 0 {
            return false
        }

        let allowedCharacters = CharacterSet(charactersIn: "-0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
