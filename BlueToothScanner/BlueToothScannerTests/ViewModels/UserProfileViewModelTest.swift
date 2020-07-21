import XCTest
@testable import BlueToothScanner

class UserProfileViewModelTest: XCTestCase {
    var viewModel : UserProfileViewModel!
    let url = URL(string: "https://anypoint.mulesoft.com/mocking/api/v1/links/6b4d76c6-59e1-462d-b0ec-a2034c899983/user-info")!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        let netWorkProvider = NetworkProvider(urlSession: urlSession)
        
        let userInfoService = UserServices(networkProvider: netWorkProvider)
        self.viewModel = UserProfileViewModel(userService: userInfoService)
    }
    
    func testFecthUserSuccess() {
        
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
        
        wait(for: [expect], timeout: 1)
        XCTAssertNotNil(self.viewModel.userInfo)
        
    }
    func testFecthUserFail() {
        
        let expect = expectation(description: "Expectation")
        let path = Bundle(for: type(of: self)).url(forResource: "user.json", withExtension: nil)
        let userData = try? Data(contentsOf: path!)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            
            return (response, userData)
        }
        
        
        self.viewModel.fetchUser {
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1)
        XCTAssertNil(self.viewModel.userInfo)
        XCTAssertNotNil(self.viewModel.error)
        
    }
}
