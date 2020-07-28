//import XCTest
//@testable import BlueToothScanner
//
//class BluetoothServiceTest: XCTestCase {
//    var blueToothService: BluetoothService!
//    var centralManagerMock: CBCentralManagerMock!
//
//    override func setUp() {
//
//        self.centralManagerMock = CBCentralManagerMock()
//        self.blueToothService = BluetoothService.shared
//        self.blueToothService.setDefaultCBManager(manager: self.centralManagerMock.mock)
//    }
//
//    override func tearDown() {
//        self.centralManagerMock = nil
//        self.centralManagerMock = nil
//        super.tearDown()
//    }
//
//    func testIsAuthority() {
//        self.centralManagerMock.setState(.unauthorized)
//        XCTAssertFalse(self.blueToothService.isAuthority)
//
//        self.centralManagerMock.setState(.poweredOn)
//        XCTAssertTrue(self.blueToothService.isAuthority)
//
//        self.centralManagerMock.setState(.poweredOff)
//        XCTAssertTrue(self.blueToothService.isAuthority)
//    }
//}
