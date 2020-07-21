import XCTest
@testable import BlueToothScanner

class FilterSettingViewControllerTests: XCTestCase {
    private var filterSettingVC: FilterSettingViewController!

    override func setUp() {
        super.setUp()
        let viewModel = FillterSettingViewModel(model: FilterModel())
        self.filterSettingVC = FilterSettingViewController.create(viewModel: viewModel)
        self.filterSettingVC.loadViewIfNeeded()
    }

    func testTextFieldShouldReturn() {
        //ensure input correct value type
        _ = [filterSettingVC.rssiToTextField, filterSettingVC.rssiFromTextField]
            .map { (textField) in
                let validInput = self.canInsertTextIn(
                    textField: self.filterSettingVC.rssiToTextField,
                    string: "1"
                )

                let validInput1 = self.canInsertTextIn(
                    textField: self.filterSettingVC.rssiToTextField,
                    string: "-"
                )

                let invalidInput = self.canInsertTextIn(
                    textField: self.filterSettingVC.rssiToTextField,
                    string: "a"
                )

                XCTAssertTrue(validInput)
                XCTAssertTrue(validInput1)
                XCTAssertFalse(invalidInput)
        }
    }

    func testAllControllAreConnected() {
        _ = try? XCTUnwrap(filterSettingVC.rssiFromTextField, "not connected")
        _ = try? XCTUnwrap(filterSettingVC.rssiToTextField, "not connected")
        _ = try? XCTUnwrap(filterSettingVC.rssiSwitchControll, "not connected")
        _ = try? XCTUnwrap(filterSettingVC.emptyDeviceNameSwitchControll, "not connected")
    }
    func testbindViewModel() {
        let viewModel = FillterSettingViewModel(model: FilterModel())
        self.filterSettingVC = FilterSettingViewController.create(viewModel: viewModel)
        self.filterSettingVC.loadViewIfNeeded()

        XCTAssertEqual(self.filterSettingVC.rssiFromTextField.text, "")
        XCTAssertEqual(self.filterSettingVC.rssiToTextField.text, "")
        XCTAssertEqual(self.filterSettingVC.rssiSwitchControll.isOn, false)
        XCTAssertEqual(self.filterSettingVC.emptyDeviceNameSwitchControll.isOn, true)

        let filterModel = FilterModel(rssiFrom: 10,
                                      rssiTo: 12,
                                      fillterRSSI: true,
                                      fillterEmptyName: true)
        let viewModel1 = FillterSettingViewModel(model: filterModel)
        self.filterSettingVC = FilterSettingViewController.create(viewModel: viewModel1)
        self.filterSettingVC.loadViewIfNeeded()

        XCTAssertEqual(self.filterSettingVC.rssiFromTextField.text, "10")
        XCTAssertEqual(self.filterSettingVC.rssiToTextField.text, "12")
        XCTAssertEqual(self.filterSettingVC.rssiSwitchControll.isOn, true)
        XCTAssertEqual(self.filterSettingVC.emptyDeviceNameSwitchControll.isOn, true)
    }

}
extension FilterSettingViewControllerTests {
    func canInsertTextIn(textField: UITextField, string: String) -> Bool {
        let range = NSRange(location: textField.text!.count, length: textField.text!.count + string.count)
        return (textField.delegate?
            .textField?(textField,
                        shouldChangeCharactersIn: range,
                        replacementString: string))!
    }
}
