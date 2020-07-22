import XCTest
@testable import BlueToothScanner

class BluetoothViewControllerTest: XCTestCase {
    private var bluetoothVC: BluetoothViewController!

    override func setUp() {
        super.setUp()
        self.bluetoothVC = BluetoothViewController.create()
        self.bluetoothVC.loadViewIfNeeded()
    }
    func testSetupNavigationBar() {
        XCTAssertEqual(bluetoothVC.navigationItem.rightBarButtonItem?.title, "Filter")
    }
}
