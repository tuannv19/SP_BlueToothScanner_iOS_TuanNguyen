//import XCTest
//@testable import BlueToothScanner
//
//class UserProfileViewControllerTest: XCTestCase {
//    private var userProfileVC: UserProfileViewController!
//
//    override func setUp() {
//        super.setUp()
//        self.userProfileVC = UserProfileViewController.create()
//        self.userProfileVC.loadViewIfNeeded()
//    }
//    override func tearDown() {
//        self.userProfileVC = nil
//    }
//    func testAllControlAreConnected() {
//        _ = try? XCTUnwrap(self.userProfileVC.avatarImageView, "not connected")
//        _ = try? XCTUnwrap(self.userProfileVC.nameLabel, "not connected")
//        _ = try? XCTUnwrap(self.userProfileVC.userNameLabel, "not connected")
//        _ = try? XCTUnwrap(self.userProfileVC.phoneLabel, "not connected")
//        _ = try? XCTUnwrap(self.userProfileVC.companyLabel, "not connected")
//        _ = try? XCTUnwrap(self.userProfileVC.addressLabel, "not connected")
//    }
//    func testBinUserInfo() {
//        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
//        let userData = try? Data(contentsOf: path!)
//        let userInfo = try? JSONDecoder().decode(UserInfo.self, from: userData!)
//
//        self.userProfileVC.viewModel.userInfo.value = userInfo
//        let ex = expectation(description: "")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertEqual(self.userProfileVC.phoneLabel.text, userInfo?.phone)
//            XCTAssertTrue(self.userProfileVC.stackView.isHidden)
//            ex.fulfill()
//        }
//        wait(for: [ex], timeout: 0.1)
//    }
//    func testBindError() {
//        self.userProfileVC.viewModel.error.value = .noResultError
//        let ex = expectation(description: "")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertTrue(self.userProfileVC.stackView.isHidden)
//            ex.fulfill()
//        }
//        wait(for: [ex], timeout: 0.1)
//    }
//    func testBindIsFetching() {
//        self.userProfileVC.viewModel.isFetchingData.value = false
//        let ex = expectation(description: "")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertFalse(self.userProfileVC.loadingIndicator.isAnimating)
//            ex.fulfill()
//        }
//        wait(for: [ex], timeout: 0.1)
//    }
//    func testBindImage() {
//        self.userProfileVC.viewModel.userAvatar.value = UIImage()
//        let ex = expectation(description: "")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertNotNil(self.userProfileVC.avatarImageView.image)
//            ex.fulfill()
//        }
//        wait(for: [ex], timeout: 0.1)
//    }
//
//    func testRightBarButtonClick() {
//        self.userProfileVC.rightBarButtonCLick()
//        XCTAssertTrue(userProfileVC.viewModel.isFetchingData.value)
//    }
//    func testHadImplementAllClosure() {
//        XCTAssertNotNil(self.userProfileVC.viewModel.error)
//        XCTAssertNotNil(self.userProfileVC.viewModel.userInfo)
//    }
//}
