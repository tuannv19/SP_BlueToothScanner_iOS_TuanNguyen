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
    func testAllControlAreConnected() {
        _ = try? XCTUnwrap(self.bluetoothVC.bluetoothScanIndicator, "not connected")
        _ = try? XCTUnwrap(self.bluetoothVC.tableView, "not connected")
        _ = try? XCTUnwrap(self.bluetoothVC.navigationItem.rightBarButtonItem, "not connected")
    }
}
