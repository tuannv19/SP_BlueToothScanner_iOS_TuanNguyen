import XCTest
@testable import BlueToothScanner

class BluetoothServiceTest: XCTestCase {
    var blueToothService: BluetoothService!
    override func setUp() {
        self.blueToothService = BluetoothService.shared
    }
    func testIsAuthority() {

    }
}
