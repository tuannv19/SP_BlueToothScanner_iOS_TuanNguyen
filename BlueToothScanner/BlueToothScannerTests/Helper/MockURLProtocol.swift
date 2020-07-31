//import Foundation
//
//protocol URLSessionDataTaskProtocol {
//    func resume()
//    func cancel()
//}
//
//protocol URLSessionProtocol {
//    func dataTask(
//        with request: URLRequest,
//        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
//    ) -> URLSessionDataTask
//}
//
//extension URLSession: URLSessionProtocol {}
//extension URLSessionDataTask: URLSessionDataTaskProtocol {}
//
//class MockURLProtocol: URLProtocol {
//
//    override class func canInit(with request: URLRequest) -> Bool {
//        // To check if this protocol can handle the given request.
//        return true
//    }
//
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        // Here you return the canonical version of the request but most of the time you pass the orignal one.
//        return request
//    }
//
//    // 1. Handler to test the request and return mock response.
//    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
//
//    override func stopLoading() {
//        // This is called if the request gets canceled or completed.
//    }
//
//    override func startLoading() {
//        guard let handler = MockURLProtocol.requestHandler else {
//            fatalError("Handler is unavailable.")
//        }
//
//        do {
//            // 2. Call handler with received request and capture the tuple of response and data.
//            let (response, data) = try handler(request)
//
//            // 3. Send received response to the client.
//            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
//
//            if let data = data {
//                // 4. Send received data to the client.
//                client?.urlProtocol(self, didLoad: data)
//            }
//
//            // 5. Notify request has been finished.
//            client?.urlProtocolDidFinishLoading(self)
//        } catch {
//            // 6. Notify received error.
//            client?.urlProtocol(self, didFailWithError: error)
//        }
//    }
//
//    static func create(code: Int, data: Data? = Data(), url: URL?)
//        -> ((URLRequest) throws -> (HTTPURLResponse, Data?))? {
//            return { request in
//                let response = HTTPURLResponse(url: url!,
//                                               statusCode: code,
//                                               httpVersion: nil,
//                                               headerFields: nil)!
//                return (response, data)
//            }
//    }
//}
import CoreBluetooth
@testable import BlueToothScanner
extension BluetoothService{
    func setCBManagerMock(cbManager: CBCentralManager) {
        self.cbManager = cbManager
    }
}
