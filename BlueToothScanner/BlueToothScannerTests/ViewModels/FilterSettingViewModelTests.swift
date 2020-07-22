import XCTest

@testable import BlueToothScanner

class FilterSettingViewModelTests: XCTestCase {

    private var filterModel: FilterSettingViewModel!

    override func setUp() {
        super.setUp()
        self.filterModel = FilterSettingViewModel(model: FilterModel())
    }

    override func tearDown() {
        self.filterModel = nil
        super.tearDown()
    }

    func testFilterModelError() {
        let error = FilterSettingViewModel.FilterModelError.fromMustLessThanTo
        XCTAssertEqual(error.localizedDescription, "fromMustLessThanTo")
    }

    func testVerifyBluetoothState() {
        self.filterModel.verifyBluetoothState(fromRSSI: -1,
                                              toRSSI: -21,
                                              filterRSSI: true,
                                              filterEmptyName: false
        ) { (model, error) in
            XCTAssertNil(model)
            XCTAssertNotNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: nil,
                                              toRSSI: -21, filterRSSI: true,
                                              filterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: nil,
                                              toRSSI: nil,
                                              filterRSSI: true,
                                              filterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: -12,
                                              toRSSI: nil,
                                              filterRSSI: true,
                                              filterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: -32,
                                              toRSSI: -21,
                                              filterRSSI: true,
                                              filterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertEqual(model?.rssiFrom, -32, "")
            XCTAssertEqual(model?.rssiTo, -21, "")
            XCTAssertEqual(model?.filterRSSI, true, "")
            XCTAssertEqual(model?.filterEmptyName, false, "")

            XCTAssertNil(error)
        }
    }
    func testShouldChangeCharactersIn() {
        let validInput = self.filterModel
            .shouldChangeCharactersIn(currentText: "",
                                      range: NSRange(location: 0, length: 1),
                                      replacementString: "1")

        let inValidInput = self.filterModel
        .shouldChangeCharactersIn(currentText: "",
                                  range: NSRange(location: 0, length: 1),
                                  replacementString: "a")

        let invalidInputStringLengt = "1234567898889989"
        let invalidInputLength = self.filterModel
        .shouldChangeCharactersIn(currentText: "",
                                  range: NSRange(location: 0, length: 1),
                                  replacementString: invalidInputStringLengt)

        let validSpecialInputString = "-"
        let validSpecialInput = self.filterModel
        .shouldChangeCharactersIn(currentText: "",
                                  range: NSRange(location: 0, length: 1),
                                  replacementString: validSpecialInputString)

        let invalidSpecialInputString = "-"
        let invalidSpecialInput = self.filterModel
        .shouldChangeCharactersIn(currentText: "1",
                                  range: NSRange(location: 1, length: 2),
                                  replacementString: invalidSpecialInputString)

        XCTAssertTrue(validInput)
        XCTAssertTrue(validSpecialInput)

        XCTAssertFalse(inValidInput)
        XCTAssertFalse(invalidInputLength)
        XCTAssertFalse(invalidSpecialInput)

    }

}
