import XCTest
@testable import BlueToothScanner

class UserInfoServiceTest: XCTestCase {
    var userInfoService : UserServices!
    let url = URL(string: "https://anypoint.mulesoft.com/mocking/api/v1/links/6b4d76c6-59e1-462d-b0ec-a2034c899983/user-info")!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        let netWorkProvider = NetworkProvider(urlSession: urlSession)
        
        self.userInfoService = UserServices(networkProvider: netWorkProvider)
    }
    func testInit()  {
        XCTAssertNotNil(self.userInfoService.networkProvider)
    }
    func testfecthUserInfoSuccess() {
        
        var responseData: UserInfo?
        var err: NetworkError?
        
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
        
        self.userInfoService.fecthUserInfo { result in
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
    func testfecthUserInfoSuccessButEmptyData() {
        
        var responseData: UserInfo?
        var err: NetworkError?
        
        let expect = expectation(description: "Expectation")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response, Data())
        }
        
        self.userInfoService.fecthUserInfo { result in
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
    func testfecthUserInfoError() {
        var responseData: UserInfo?
        var err: NetworkError?
        
        let expect = expectation(description: "Expectation")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }
        
        self.userInfoService.fecthUserInfo { result in
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
}
