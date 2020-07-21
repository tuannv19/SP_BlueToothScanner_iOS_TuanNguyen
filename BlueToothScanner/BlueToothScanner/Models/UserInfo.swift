import Foundation

// MARK: - UserInfo
struct UserInfo: Codable {
    let id: Int
    let name, username, email: String
    let avatar: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
extension UserInfo {
    func getFullAddress() -> String {
        return """
        \(self.address.street), \(self.address.building)",
        \(self.address.unit), \(self.address.city), \(self.address.zipcode)
        """
    }
}
// MARK: - Address
struct Address: Codable {
    let street, building, unit, city: String
    let zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name: String
}
