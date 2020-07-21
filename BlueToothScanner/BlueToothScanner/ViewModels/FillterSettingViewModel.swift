import Foundation

class FillterSettingViewModel {
    
    internal static let MaxNumCharacters = 5

    public enum FillterModelError: Error {
        case fromMustLessThanTo
        var localizedDescription : String {
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
                              fillterRSSI: Bool,
                              fillterEmptyName: Bool,
                              completion:((FilterModel?, FillterModelError?)->Void)?){
        
        if let fromRSSI = fromRSSI,
            let toRSSI = toRSSI,
            fromRSSI > toRSSI {
            completion?(nil, .fromMustLessThanTo)
            return
        }
        
        self.filterModel.rssiFrom = fromRSSI
        self.filterModel.rssiTo = toRSSI
        self.filterModel.fillterRSSI = fillterRSSI
        self.filterModel.fillterEmptyName = fillterEmptyName
        
        completion?(self.filterModel, nil)
    }
    func shouldChangeCharactersIn (currentText:String,
                                   range: NSRange,
                                   replacementString string: String) -> Bool {
        let newLength = currentText.count + string.count - range.length
        if (newLength >= Self.MaxNumCharacters){
            return false
        }
        
        if string == "-", range.location != 0 {
            return false
        }
        
        let allowedCharacters = CharacterSet(charactersIn:"-0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
