import XCTest
@testable import BlueToothScanner

class PermissionViewModelTests: XCTestCase {
    private let viewModel = PermissionViewModel()

    var centralManagerMock: CBCentralManagerMock!

    override func setUp() {
        self.centralManagerMock = CBCentralManagerMock()
        BluetoothService.shared.setDefaultCBManager(manager: centralManagerMock.mock)
    }

    override func tearDown() {
        self.centralManagerMock = nil
        super.tearDown()
    }

    func testVerifyAndProcessNextScreen() {
        var err: BLError?
        let expectUnknown = expectation(description: "Expectation-unknown")
        self.centralManagerMock.setState(.unknown)
        self.viewModel.verifyAndProcessNextScreen { (error) in
            err = error
            expectUnknown.fulfill()
        }
        wait(for: [expectUnknown], timeout: 0.5)
        XCTAssertEqual(err?.localizedDescription, "unknown")

        let expectPowerOn = expectation(description: "Expectation-powerOn")
        self.centralManagerMock.setState(.poweredOn)
        self.viewModel.verifyAndProcessNextScreen { (error) in
            err = error
            expectPowerOn.fulfill()
        }
        wait(for: [expectPowerOn], timeout: 0.5)
        XCTAssertNil(err)

        let expectPowerOff = expectation(description: "Expectation-powerOff")
        self.centralManagerMock.setState(.poweredOff)
        self.viewModel.verifyAndProcessNextScreen { (error) in
            err = error
            expectPowerOff.fulfill()
        }
        wait(for: [expectPowerOff], timeout: 0.5)
        XCTAssertEqual(err?.localizedDescription, "poweredOff")

        let expectUnauthorized = expectation(description: "Expectation-unauthorized")
        self.centralManagerMock.setState(.unauthorized)
        self.viewModel.verifyAndProcessNextScreen { (error) in
            err = error
            expectUnauthorized.fulfill()
        }
        wait(for: [expectUnauthorized], timeout: 0.5)
        XCTAssertEqual(err?.localizedDescription, "unauthorized")

        let expectResetting = expectation(description: "Expectation-resetting")
        self.centralManagerMock.setState(.resetting)
        self.viewModel.verifyAndProcessNextScreen { (error) in
            err = error
            expectResetting.fulfill()
        }
        wait(for: [expectResetting], timeout: 0.5)
        XCTAssertEqual(err?.localizedDescription, "resetting")

        let expectUnsupported = expectation(description: "Expectation-unsupported")
        self.centralManagerMock.setState(.unsupported)
        self.viewModel.verifyAndProcessNextScreen { (error) in
            err = error
            expectUnsupported.fulfill()
        }
        wait(for: [expectUnsupported], timeout: 0.5)
        XCTAssertEqual(err?.localizedDescription, "unsupported")
    }

}
