import XCTest
import CoreBluetooth
@testable import BlueToothScanner

class BluetoothViewModelTest: XCTestCase {
    var bluetoothViewModel: BluetoothViewModel!

    override func setUp() {
        self.bluetoothViewModel = BluetoothViewModel()
    }
    override func tearDown() {
        self.bluetoothViewModel = nil
        super.tearDown()
    }
    func testApplyFilter() {

    }
//    func testBlueToothStartScan() {
//        self.bluetoothViewModel.initialBluetoothService()
//        self.bluetoothViewModel.startScan()
//        XCTAssertEqual(self.bluetoothViewModel.isScanning.value, true)
//    }

//    func testBlueToothStopScan() {
//        self.bluetoothViewModel.initialBluetoothService()
//        self.bluetoothViewModel.stopScan()
//        XCTAssertEqual(self.bluetoothViewModel.isScanning.value, false)
//    }

}
