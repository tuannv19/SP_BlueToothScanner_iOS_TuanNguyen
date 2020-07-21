import XCTest

@testable import BlueToothScanner

class FilterSettingViewModelTests: XCTestCase {

    private var filterModel: FillterSettingViewModel!

    override func setUp() {
        super.setUp()
        self.filterModel = FillterSettingViewModel(model: FilterModel())
    }

    func testFillterModelError() {
        let error = FillterSettingViewModel.FillterModelError.fromMustLessThanTo
        XCTAssertEqual(error.localizedDescription, "fromMustLessThanTo")
    }

    func testVerifyBluetoothState() {
        self.filterModel.verifyBluetoothState(fromRSSI: -1,
                                              toRSSI: -21,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNil(model)
            XCTAssertNotNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: nil,
                                              toRSSI: -21, fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: nil,
                                              toRSSI: nil,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: -12,
                                              toRSSI: nil,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }

        self.filterModel.verifyBluetoothState(fromRSSI: -32,
                                              toRSSI: -21,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertEqual(model?.rssiFrom, -32, "")
            XCTAssertEqual(model?.rssiTo, -21, "")
            XCTAssertEqual(model?.fillterRSSI, true, "")
            XCTAssertEqual(model?.fillterEmptyName, false, "")

            XCTAssertNil(error)
        }
    }
    func testshouldChangeCharactersIn() {
        let vaildInput = self.filterModel
            .shouldChangeCharactersIn(currentText: "",
                                      range: NSRange(location: 0, length: 1),
                                      replacementString: "1")

        let inVaildInput = self.filterModel
        .shouldChangeCharactersIn(currentText: "",
                                  range: NSRange(location: 0, length: 1),
                                  replacementString: "a")

        let invalidInputStringLengt = "1234567898889989"
        let inVaildInputLenght = self.filterModel
        .shouldChangeCharactersIn(currentText: "",
                                  range: NSRange(location: 0, length: 1),
                                  replacementString: invalidInputStringLengt)

        let validSpecialInputString = "-"
        let vaildSpecialInput = self.filterModel
        .shouldChangeCharactersIn(currentText: "",
                                  range: NSRange(location: 0, length: 1),
                                  replacementString: validSpecialInputString)

        let invalidSpecialInputString = "-"
        let invaildSpecialInput = self.filterModel
        .shouldChangeCharactersIn(currentText: "1",
                                  range: NSRange(location: 1, length: 2),
                                  replacementString: invalidSpecialInputString)

        XCTAssertTrue(vaildInput)
        XCTAssertTrue(vaildSpecialInput)

        XCTAssertFalse(inVaildInput)
        XCTAssertFalse(inVaildInputLenght)
        XCTAssertFalse(invaildSpecialInput)

    }

}
