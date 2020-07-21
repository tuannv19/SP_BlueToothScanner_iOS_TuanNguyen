import XCTest
@testable import BlueToothScanner

class UserProfileViewControllerTest: XCTestCase {
    private var userProfileVC: UserProfileViewController!
    
    override func setUp() {
        super.setUp()
        self.userProfileVC = UserProfileViewController.create()
        self.userProfileVC.loadViewIfNeeded()
    }
    func testAllControllAreConnected(){
        _ = try? XCTUnwrap(self.userProfileVC.avatarImageView, "not connected")
        _ = try? XCTUnwrap(self.userProfileVC.nameLabel, "not connected")
        _ = try? XCTUnwrap(self.userProfileVC.userNameLabel, "not connected")
        _ = try? XCTUnwrap(self.userProfileVC.phoneLabel, "not connected")
        _ = try? XCTUnwrap(self.userProfileVC.companyLabel, "not connected")
        _ = try? XCTUnwrap(self.userProfileVC.addressLabel, "not connected")
    }
    func testHadImplementAllClourse() {
        XCTAssertNotNil(self.userProfileVC.viewModel.errorHasOcur)
        XCTAssertNotNil(self.userProfileVC.viewModel.userInfoDidChange)
    }
}
