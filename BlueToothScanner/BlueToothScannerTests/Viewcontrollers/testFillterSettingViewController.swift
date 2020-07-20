import XCTest
@testable import BlueToothScanner

class testFilterSettingViewController: XCTestCase {
    private var fillterSettingVC: FilterSettingViewController!
    
    override func setUp() {
        super.setUp()
        self.fillterSettingVC = FilterSettingViewController.Create()
        self.fillterSettingVC.loadViewIfNeeded()
    }
    
    func testTextFieldShouldReturn() {
        //ensure input numberOnly
        _ = [fillterSettingVC.rssiToTextField, fillterSettingVC.rssiFromTextField]
            .map { (textField) in
                let validInput = self.canInsertTextIn(
                    textField: fillterSettingVC.rssiToTextField,
                    string: "1"
                )
                
                let validInput1 = self.canInsertTextIn(
                    textField: fillterSettingVC.rssiToTextField,
                    string: "-"
                )
                
                let invalidInput = self.canInsertTextIn(
                    textField: fillterSettingVC.rssiToTextField,
                    string: "a"
                )
                
                XCTAssertTrue(validInput)
                XCTAssertTrue(validInput1)
                XCTAssertFalse(invalidInput)
        }
    }
    
    func testAllControllAreConnected(){
        _ = try? XCTUnwrap(fillterSettingVC.rssiFromTextField, "not connected")
        _ = try? XCTUnwrap(fillterSettingVC.rssiToTextField, "not connected")
        _ = try? XCTUnwrap(fillterSettingVC.rssiSwitchControll, "not connected")
        _ = try? XCTUnwrap(fillterSettingVC.emptyDeviceNameSwitchControll, "not connected")
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
