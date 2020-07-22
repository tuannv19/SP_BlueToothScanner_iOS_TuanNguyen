import XCTest
@testable import BlueToothScanner

class BLErrorTest: XCTestCase {
    func testBLError() {
        XCTAssertEqual(BLError.BLErrorReason.poweredOff.localizedDescription, "poweredOff")
        XCTAssertEqual(BLError.BLErrorReason.unauthorized.localizedDescription, "unauthorized")
        XCTAssertEqual(BLError.BLErrorReason.resetting.localizedDescription, "resetting")
        XCTAssertEqual(BLError.BLErrorReason.unsupported.localizedDescription, "unsupported")
        XCTAssertEqual(BLError.BLErrorReason.unknown.localizedDescription, "unknown")
        XCTAssertEqual(BLError.bluetoothUnavailable(reason: .poweredOff).localizedDescription, "poweredOff")
    }
}
