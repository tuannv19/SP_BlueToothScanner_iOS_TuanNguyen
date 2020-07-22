import XCTest
@testable import BlueToothScanner

class BluetoothViewControllerTest: XCTestCase {
    private var bluetoothVC: BluetoothViewController!

    override func setUp() {
        super.setUp()
        self.bluetoothVC = BluetoothViewController.create()
        self.bluetoothVC.loadViewIfNeeded()
    }

    func testCreate() {
        let vc = BluetoothViewController.create()
        XCTAssertNotNil(vc)
    }
}
