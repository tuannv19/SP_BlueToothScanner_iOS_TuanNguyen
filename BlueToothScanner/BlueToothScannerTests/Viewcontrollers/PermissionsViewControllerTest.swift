import XCTest
@testable import BlueToothScanner

class PermissionsViewControllerTest: XCTestCase {
    var centralManagerMock: CBCentralManagerMock!
    var permissionVC: PermissionsViewController!

    override func setUp() {
        self.centralManagerMock = CBCentralManagerMock()
        BluetoothService.shared.setDefaultCBManager(manager: centralManagerMock.mock)

        self.permissionVC = PermissionsViewController.create()
        self.permissionVC.loadViewIfNeeded()
    }
    override func tearDown() {
        self.centralManagerMock = nil
        self.permissionVC = nil
        super.tearDown()
    }
    func testCreateTabBar() {
        let tabBar = PermissionsViewController.createTabBar()
        XCTAssertNotNil(tabBar)
    }
    func testMoveToTabBarController() {
        self.permissionVC.moveToTabBarController()
        XCTAssert(UIApplication.shared.keyWindow?.rootViewController is UITabBarController)
    }
}
