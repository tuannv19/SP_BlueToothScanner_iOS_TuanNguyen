import XCTest

@testable import BlueToothScanner

class testFilterSettingViewModel: XCTestCase {

    private var filterModel : FillterSettingViewModel!
    
    override func setUp() {
        super.setUp()
        self.filterModel = FillterSettingViewModel()
    }
    
    func testVerifyBluetoothState() {
        self.filterModel.verifyBluetoothState(fromRSSI: -1,
                                              toRSSI: -21,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNil(model)
            XCTAssertNotNil(error)
        }
        
        self.filterModel.verifyBluetoothState(fromRSSI: nil,
                                              toRSSI: -21, fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }
        
        self.filterModel.verifyBluetoothState(fromRSSI: nil,
                                              toRSSI: nil,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }
        
        self.filterModel.verifyBluetoothState(fromRSSI: -12,
                                              toRSSI: nil,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertNil(error)
        }
        
        self.filterModel.verifyBluetoothState(fromRSSI: -32,
                                              toRSSI: -21,
                                              fillterRSSI: true,
                                              fillterEmptyName: false
        ) { (model, error) in
            XCTAssertNotNil(model)
            XCTAssertEqual(model?.rssiFrom, -32, "")
            XCTAssertEqual(model?.rssiTo, -21, "")
            XCTAssertEqual(model?.fillterRSSI, true, "")
            XCTAssertEqual(model?.fillterEmptyName, false, "")
            
            XCTAssertNil(error)
        }
    }
    

}
