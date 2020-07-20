import Foundation

class FillterSettingViewModel {
    
    enum FillterModelError: Error {
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
        
        if let fromRSSI = fromRSSI, let toRSSI = toRSSI, fromRSSI > toRSSI {
            completion?(nil, .fromMustLessThanTo)
            return
        }
        
        self.filterModel.rssiFrom = fromRSSI
        self.filterModel.rssiTo = toRSSI
        self.filterModel.fillterRSSI = fillterRSSI
        self.filterModel.fillterEmptyName = fillterEmptyName
        
        completion?(self.filterModel, nil)
    }
}
