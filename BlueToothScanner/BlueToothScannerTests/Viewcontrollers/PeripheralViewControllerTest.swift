import XCTest
@testable import BlueToothScanner

class PeripheralViewControllerTest: XCTestCase {
    private var peripheralVC: PeripheralViewController!

    override func setUp() {
        let mock = CBPeripheralMock(uuid: "d61b7fc3-4883-4cc4-9880-6558e8bf9761").mock

        let peripheralInfo: PeripheralInfo = (mock, [:], -1)
        let peripheralModel = PeripheralModel(info: peripheralInfo)
        self.peripheralVC = PeripheralViewController.create(peripheral: peripheralModel!)
    }

    func testCreate() {
        let mock = CBPeripheralMock(uuid: "d61b7fc3-4883-4cc4-9880-6558e8bf9761").mock

        let peripheralInfo: PeripheralInfo = (mock, [:], -1)
        let peripheralModel = PeripheralModel(info: peripheralInfo)
        let vc = PeripheralViewController.create(peripheral: peripheralModel!)
        vc.loadViewIfNeeded()

        XCTAssertNotNil(vc.infoTextView.text)
        XCTAssertNotNil(vc)
    }

}
