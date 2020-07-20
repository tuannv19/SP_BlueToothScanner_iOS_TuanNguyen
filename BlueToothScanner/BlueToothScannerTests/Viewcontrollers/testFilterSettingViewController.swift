import XCTest
@testable import BlueToothScanner

class testFilterSettingViewController: XCTestCase {
    private var filterSettingVC: FilterSettingViewController!
    
    override func setUp() {
        super.setUp()
        self.filterSettingVC = FilterSettingViewController.Create()
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
    
    func testAllControllAreConnected(){
        _ = try? XCTUnwrap(filterSettingVC.rssiFromTextField, "not connected")
        _ = try? XCTUnwrap(filterSettingVC.rssiToTextField, "not connected")
        _ = try? XCTUnwrap(filterSettingVC.rssiSwitchControll, "not connected")
        _ = try? XCTUnwrap(filterSettingVC.emptyDeviceNameSwitchControll, "not connected")
    }
}
extension testFilterSettingViewController{
    func canInsertTextIn(textField: UITextField, string: String) -> Bool {
        let range = NSMakeRange(textField.text!.count,
                                textField.text!.count + string.count)
        return (textField.delegate?
            .textField?(textField,
                        shouldChangeCharactersIn: range,
                        replacementString: string))!
    }
}
