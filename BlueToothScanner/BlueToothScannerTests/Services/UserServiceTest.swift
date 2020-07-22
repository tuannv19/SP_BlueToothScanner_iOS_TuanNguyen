import XCTest
@testable import BlueToothScanner

class UserServiceTest: XCTestCase {
    var userInfoService: UserServices!
    let url = URL(string: "https://anypoint.mulesoft.com/mocking/api/v1/links/6b4d76c6-59e1-462d-b0ec-a2034c899983/user-info")!

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        let netWorkProvider = NetworkProvider(urlSession: urlSession)

        self.userInfoService = UserServices(networkProvider: netWorkProvider)
    }

    func testInit() {
        XCTAssertNotNil(self.userInfoService.networkProvider)
    }
    func testFetchUserInfoSuccess() {

        var responseData: UserInfo?
        var err: NetworkError?

        let expect = expectation(description: "Expectation")
        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
        let userData = try? Data(contentsOf: path!)

        MockURLProtocol.requestHandler = MockURLProtocol.create(
            code: 200,
            data: userData,
            url: self.url
        )

        self.userInfoService.fetchUserInfo { result in
            switch result {
            case .failure(let error) :
                err = error
            case .success(let userInfo) :
                responseData = userInfo
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertNotNil(responseData)
        XCTAssertNil(err)
    }
    func testFecthUserInfoSuccessButEmptyData() {

        var responseData: UserInfo?
        var err: NetworkError?

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = MockURLProtocol.create(
            code: 200,
            url: self.url
        )

        self.userInfoService.fetchUserInfo { result in
            switch result {
            case .failure(let error) :
                err = error
            case .success(let userInfo) :
                responseData = userInfo
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertNil(responseData)
        XCTAssertEqual(err, NetworkError.noResultError)
    }
    func testFetchUserInfoError() {
        var responseData: UserInfo?
        var err: NetworkError?

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = MockURLProtocol.create(code: 404, url: self.url)

        self.userInfoService.fetchUserInfo { result in
            switch result {
            case .failure(let error) :
                err = error
            case .success(let userInfo) :
                responseData = userInfo
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)

        XCTAssertEqual(err, NetworkError.notFoundError)
        XCTAssertNil(responseData)
    }

    func testFetchDataSuccess() {
        var responseData: Data?
        var err: NetworkError?

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = MockURLProtocol.create(
            code: 200,
            data: UIImage().pngData(),
            url: self.url
        )

        self.userInfoService.fetchData(url: self.url.absoluteString) { result in
            switch result {
            case .failure(let error) :
                err = error
            case .success(let userInfo) :
                responseData = userInfo
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertNotNil(responseData)
        XCTAssertNil(err)
    }

    func testFetchDataFail() {
        var responseData: Data?
        var err: NetworkError?

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = MockURLProtocol.create(
            code: 404,
            data: UIImage().pngData(),
            url: self.url
        )

        self.userInfoService.fetchData(url: self.url.absoluteString) { result in
            switch result {
            case .failure(let error) :
                err = error
            case .success(let userInfo) :
                responseData = userInfo
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)
        XCTAssertNotNil(err)
    }
}
