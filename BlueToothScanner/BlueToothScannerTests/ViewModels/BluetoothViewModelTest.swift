import XCTest
import CoreBluetooth
@testable import BlueToothScanner

class BluetoothViewModelTest: XCTestCase {
    var bluetoothViewModel: BluetoothViewModel!
    var centralManagerMock: CBCentralManagerMock!

    override func setUp() {
        self.bluetoothViewModel = BluetoothViewModel()
        self.centralManagerMock = CBCentralManagerMock()
        self.bluetoothViewModel
            .bluetoothService.setDefaultCBManager(manager: self.centralManagerMock.mock)
    }

    override func tearDown() {
        self.centralManagerMock = nil
        self.bluetoothViewModel = nil
        super.tearDown()
    }
    func testFilterByName() {

        //Ensure data empty
        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 0)

        let mock = CBPeripheralMock(uuid: "d61b7fc3-4883-4cc4-9880-6558e8bf9761").mock
        let peripheralInfo: PeripheralInfo = (mock, [:], -1)

        //without filter name
        self.bluetoothViewModel.filterModel.filterEmptyName = false
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfo)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 1)

        //filter name
        self.bluetoothViewModel.filterModel.filterEmptyName = true
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfo)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 0)

        let mockWithName = CBPeripheralMock(uuid: "d61b7fc3-4883-4cc4-9880-6558e8bf9761",
                                            name: "mobile").mock
        let peripheralInfoWithName: PeripheralInfo = (mockWithName, [:], -1)

        self.bluetoothViewModel.filterModel.filterEmptyName = true
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 1)

        //add more device
        let mockWithName2 = CBPeripheralMock(uuid: "d61bafc3-4883-4cc4-9880-6558e8bf9761",
                                             name: "mobile").mock
        let peripheralInfoWithName2: PeripheralInfo = (mockWithName2, [:], -1)
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName2)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 2)

    }
    func testFilterByRSSI() {
        //Ensure data empty
        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 0)

        let mockWithName = CBPeripheralMock(uuid: "d61b7fc3-4883-4cc4-9880-6558e8bf9761",
                                            name: "mobile").mock
        let peripheralInfoWithName: PeripheralInfo = (mockWithName, [:], -1)
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 1)

        //filter with rssi from
        self.bluetoothViewModel.filterModel.rssiFrom = 1
        self.bluetoothViewModel.filterModel.filterRSSI = true
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 0)

        self.bluetoothViewModel.filterModel.rssiFrom = -999
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName)

        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 1)

        //filter with rssi to
        self.bluetoothViewModel.filterModel.rssiFrom = nil
        self.bluetoothViewModel.filterModel.rssiTo = 1
        self.bluetoothViewModel.filterModel.filterRSSI = true
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName)
        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 1)

        self.bluetoothViewModel.filterModel.rssiTo = -99
        self.bluetoothViewModel.addOrUpdatePeripheralIfNeed(peripheralInfo: peripheralInfoWithName)
        XCTAssertEqual(bluetoothViewModel.numberOfPeripheralModel, 0)

    }
    func testApplyNewFilter() {
        let filterModel = FilterModel(rssiFrom: -99,
                                      rssiTo: 9,
                                      filterRSSI: true,
                                      filterEmptyName: true)
        self.bluetoothViewModel.applyNewFilter(filterModel: filterModel)
        XCTAssertEqual(self.bluetoothViewModel.filterModel, filterModel)
    }

    func testBlueToothStopScan() {
        //        self.bluetoothViewModel.initialBluetoothService()
        //        self.bluetoothViewModel.stopScan()
        //        XCTAssertEqual(self.bluetoothViewModel.isScanning.value, false)
    }

}
extension BluetoothService {
    func setDefaultCBManager(manager: CBCentralManager) {
        self.cbManager = manager
    }
}
