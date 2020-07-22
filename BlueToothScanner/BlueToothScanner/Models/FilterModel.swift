import Foundation

struct FilterModel {
    var rssiFrom: Int?
    var rssiTo: Int?
    var filterRSSI: Bool = false
    var filterEmptyName: Bool = true
}
extension FilterModel: Equatable {
    static func == (lhs: FilterModel, rhs: FilterModel) -> Bool {
        return lhs.rssiFrom == rhs.rssiFrom &&
            lhs.rssiTo == rhs.rssiTo &&
            lhs.filterRSSI == rhs.filterRSSI &&
            lhs.filterEmptyName == rhs.filterEmptyName
    }
}
