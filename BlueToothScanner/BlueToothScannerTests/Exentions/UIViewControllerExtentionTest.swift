import XCTest
@testable import BlueToothScanner

class UIViewControllerExtentionTest: XCTestCase {
    func testErrorAlert() {
       let vc = UIViewController()
       UIApplication.shared.keyWindow?.rootViewController = vc
       let expectShowAlert = expectation(description: "shows alert")
        vc.showAlert(title: "", message: "") {
            expectShowAlert.fulfill()
        }
       waitForExpectations(timeout: 1)
     }

}
