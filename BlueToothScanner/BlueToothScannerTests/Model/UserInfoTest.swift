//import XCTest
//@testable import BlueToothScanner
//
//class UserInfoTest: XCTestCase {
//    func testUserInfo() {
//        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
//        let userData = try? Data(contentsOf: path!)
//        let userInfo = try? JSONDecoder().decode(UserInfo.self, from: userData!)
//
//        let address = Address(street: "180 Clemenceau Ave",
//                              building: "Haw Par Centre", unit: "#03-01/04",
//                              city: "Singapore", zipcode: "239922",
//                              geo: Geo(lat: "", lng: ""))
//        let expectUserInfo = UserInfo(id: 1,
//                                      name: "Leanne Graham", username: "Bret",
//                                      email: "", avatar: "",
//                                      address: address, phone: "",
//                                      website: "", company: Company(name: ""))
//
//        XCTAssertNotNil(userInfo)
//        XCTAssertEqual(userInfo?.name, "Leanne Graham")
//        XCTAssertEqual(userInfo?.getFullAddress(), expectUserInfo.getFullAddress())
//
//    }
//}
