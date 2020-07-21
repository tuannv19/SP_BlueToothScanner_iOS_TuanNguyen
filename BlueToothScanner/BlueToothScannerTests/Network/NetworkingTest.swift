import XCTest
@testable import BlueToothScanner

class NetworkingTest: XCTestCase {
    var networking: NetworkProvider!
    var urlSession: URLSession!
    let url = URL(string: "https://anypoint.mulesoft.com/mocking/api/v1/links/6b4d76c6-59e1-462d-b0ec-a2034c899983/user-info")!

    override func setUp() {

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession.init(configuration: configuration)
        self.networking = NetworkProvider(urlSession: urlSession)

    }

    func testNetworkError() {

        XCTAssertEqual(
            NetworkError.notFoundError.localizedDescription,
            "The request cannot be fulfilled because the resource does not exist."
        )
        XCTAssertEqual(
            NetworkError.decodingError.localizedDescription,
            "Decoding data error."
        )
        XCTAssertEqual(
            NetworkError.noResultError.localizedDescription,
            "No matching result found."
        )
        XCTAssertEqual(
            NetworkError.keyError.localizedDescription,
            "Key is invalid or expired."
        )
        XCTAssertEqual(
            NetworkError.forbiddenError.localizedDescription,
            "The request is not allowed."
        )
        XCTAssertEqual(
            NetworkError.serverError.localizedDescription,
            "The request failed due to a server-side error."
        )
        XCTAssertEqual(
            NetworkError.unknownError.localizedDescription,
            "Unknown error"
        )
    }
    func testResponseObject() {
        let responseObject = ResponseObject<UserInfo>(url: URL(string: "google.com.vn")!)
        XCTAssertEqual(responseObject.url, URL(string: "google.com.vn")!)
    }
    func testInit() {
        XCTAssertEqual(self.networking.urlSession, self.urlSession)
    }
    func testSuccessGetRequest() {

        var responseData: Data?
        var err: Error?

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        self.networking.request(requestUrl: self.url, httpMethod: .get, parameters: nil) { (data, netErr) in
            if let error = netErr {
                err = error
            } else if let data = data {
                responseData = data
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)

        XCTAssertNil(err)
        XCTAssertNotNil(responseData)
    }
    func testSuccessPostRequest() {

        var responseData: Data?
        var err: Error?

        let expect = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        self.networking.request(requestUrl: url, httpMethod: .post, parameters: ["key": "value"]) { (data, netErr) in
            if let error = netErr {
                err = error
            } else if let data = data {
                responseData = data
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 0.5)

        XCTAssertNil(err)
        XCTAssertNotNil(responseData)
    }

    // swiftlint:disable function_body_length
    func testErrorCode() {
        var err: NetworkError?

        let expect404 = expectation(description: "Expectation")

        MockURLProtocol.requestHandler = MockURLProtocol.create(code: 404,
                                                              data: Data(),
                                                              url: self.url)

        self.networking.request(requestUrl: url, httpMethod: .get, parameters: nil  ) { (_, netErr) in
            if let error = netErr {
                err = error
            }
            expect404.fulfill()
        }

        wait(for: [expect404], timeout: 0.5)
        XCTAssertEqual(err, NetworkError.notFoundError)

        let expectNetworkError = expectation(description: "Expectation")
        MockURLProtocol.requestHandler = MockURLProtocol.create(code: 200,
                                                              data: nil,
                                                              url: self.url)

        self.networking.request(requestUrl: url, httpMethod: .get, parameters: nil  ) { (_, netErr) in
            if let error = netErr {
                err = error
            }
            expectNetworkError.fulfill()
        }
        wait(for: [expectNetworkError], timeout: 0.5)
        XCTAssertEqual(err, NetworkError.notFoundError)

        let expect400 = expectation(description: "Expectation")
        MockURLProtocol.requestHandler = MockURLProtocol.create(code: 400,
                                                              data: Data(),
                                                              url: self.url)

        self.networking.request(requestUrl: url, httpMethod: .get, parameters: nil  ) { (_, netErr) in
            if let error = netErr {
                err = error
            }
            expect400.fulfill()
        }
        wait(for: [expect400], timeout: 0.5)
        XCTAssertEqual(err, NetworkError.keyError)

        let expect403 = expectation(description: "Expectation")
        MockURLProtocol.requestHandler = MockURLProtocol.create(code: 403,
                                                              data: Data(),
                                                              url: self.url)

        self.networking.request(requestUrl: url, httpMethod: .get, parameters: nil  ) { (_, netErr) in
            if let error = netErr {
                err = error
            }
            expect403.fulfill()
        }
        wait(for: [expect403], timeout: 0.5)
        XCTAssertEqual(err, NetworkError.forbiddenError)

        let expect500 = expectation(description: "Expectation")
        MockURLProtocol.requestHandler = MockURLProtocol.create(code: 500,
                                                              data: Data(),
                                                              url: self.url)

        self.networking.request(requestUrl: url, httpMethod: .get, parameters: nil  ) { (_, netErr) in
            if let error = netErr {
                err = error
            }
            expect500.fulfill()
        }
        wait(for: [expect500], timeout: 0.5)
        XCTAssertEqual(err, NetworkError.serverError)

        let expectUnknowError = expectation(description: "Expectation")
        MockURLProtocol.requestHandler = MockURLProtocol.create(code: -999,
                                                              data: Data(),
                                                              url: self.url)

        self.networking.request( requestUrl: url, httpMethod: .get, parameters: nil
        ) { (_, netErr) in
            if let error = netErr {
                err = error
            }
            expectUnknowError.fulfill()
        }
        wait(for: [expectUnknowError], timeout: 0.5)
        XCTAssertEqual(err, NetworkError.unknownError)
    }
    // swiftlint:enable function_body_length
}
