import XCTest
@testable import BlueToothScanner

class UserProfileViewModelTest: XCTestCase {
    var viewModel: UserProfileViewModel!
    let url = URL(string: "https://anypoint.mulesoft.com/mocking/api/v1/links/6b4d76c6-59e1-462d-b0ec-a2034c899983/user-info")!

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        let netWorkProvider = NetworkProvider(urlSession: urlSession)

        let userInfoService = UserServices(networkProvider: netWorkProvider)
        self.viewModel = UserProfileViewModel(userService: userInfoService)
    }
    override func tearDown() {
        self.viewModel = nil
        super.tearDown()
    }

    func testFetchUserSuccess() {

        let expect = expectation(description: "Expectation")
        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
        let userData = try? Data(contentsOf: path!)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, userData)
        }

        self.viewModel.fetchUser {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5)
        XCTAssertNotNil(self.viewModel.userInfo)

    }
    func testFetchUserFail() {

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, nil)
        }

        self.viewModel.fetchUser {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1)
        XCTAssertNil(self.viewModel.userInfo.value)
        XCTAssertNotNil(self.viewModel.error)
    }
    func testFetchDataSuccess() {
        let expect = expectation(description: "Expectation")
        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
        let userData = try? Data(contentsOf: path!)
        let userInfo = try? JSONDecoder().decode(UserInfo.self, from: userData!)
        self.viewModel.userInfo.value = userInfo

        let imagePath = Bundle(for: type(of: self)).url(
            forResource: "Sincere@spdigital.sg.png", withExtension: nil
        )
        let imageData = try? Data(contentsOf: imagePath!)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, imageData)
        }
        self.viewModel.fetchAvatarImage {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1)
        XCTAssertNotNil(self.viewModel.userAvatar.value)
    }

    func testFetchDataSuccessButEmptyResult() {
        let expect = expectation(description: "Expectation")
        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
        let userData = try? Data(contentsOf: path!)
        let userInfo = try? JSONDecoder().decode(UserInfo.self, from: userData!)
        self.viewModel.userInfo.value = userInfo

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, nil)
        }
        self.viewModel.fetchAvatarImage {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1)
        XCTAssertNil(self.viewModel.userAvatar.value)
    }
}
