import XCTest
@testable import BlueToothScanner

class PermissionsViewControllerTest: XCTestCase {

    func testCreateTabBar() {
        let tabBar = PermissionsViewController.createTabBar()
        XCTAssertNotNil(tabBar)
//        XCTAssertEqual(tabBar, UI)
    }
}
