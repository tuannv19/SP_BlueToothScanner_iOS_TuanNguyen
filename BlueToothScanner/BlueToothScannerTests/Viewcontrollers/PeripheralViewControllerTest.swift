import XCTest
@testable import BlueToothScanner

class PeripheralViewControllerTest: XCTestCase {

    func testCreate() {
        let mock = CBPeripheralMock(uuid: "d61b7fc3-4883-4cc4-9880-6558e8bf9761").mock

        let peripheralInfo: PeripheralInfo = (mock, [:], -1)
        let peripheralModel = PeripheralModel(info: peripheralInfo)
        let viewModel = PeripheralViewModel(peripheralModel: peripheralModel!)
        let vc = PeripheralViewController.create(viewModel: viewModel)
        vc.loadViewIfNeeded()

        XCTAssertNotNil(vc.infoTextView.text)
    }

}
