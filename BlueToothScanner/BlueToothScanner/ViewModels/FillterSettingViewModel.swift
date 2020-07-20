import Foundation

class FillterSettingViewModel {
    enum FillterModelError: Error {
        case fromMustLessThanTo
        var localizedDescription : String {
            return "fromMustLessThanTo"
        }
    }
    
    var didSendData: ((FilterModel) -> Void)?

    func verifyBluetoothState(fromRSSI: Int?,
                toRSSI: Int?,
                fillterRSSI: Bool?,
                fillterEmptyName: Bool?,
                completion:((FilterModel?, FillterModelError?)->Void)?){
        
        if let fromRSSI = fromRSSI, let toRSSI = toRSSI, fromRSSI > toRSSI {
            completion?(nil, .fromMustLessThanTo)
            return
        }
        
        let fillterModel = FilterModel(rssiFrom: fromRSSI,
                                       rssiTo: toRSSI,
                                       fillterRSSI: fillterRSSI ?? false,
                                       fillterEmptyName: fillterEmptyName ?? false)
        completion?(fillterModel, nil)
    }
}
