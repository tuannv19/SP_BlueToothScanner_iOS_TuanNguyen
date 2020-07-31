import XCTest
import RxTest
import RxBlocking
import RxSwift

@testable import BlueToothScanner
//
class PermissionViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var viewModel : PermissionViewModel!
    var bluetoothService: BluetoothService!
    var cbCentralManager : CBCentralManagerMock!
    
    override func setUp() {
        super.setUp()
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.viewModel = PermissionViewModel(navigator: PermissionsNavigator(nav: UINavigationController()))
        self.bluetoothService = BluetoothService.shared
        self.cbCentralManager =  CBCentralManagerMock()
        self.bluetoothService.setCBManagerMock(cbManager: self.cbCentralManager.mock)
        
    }
    override func tearDown() {
        self.scheduler = nil
        self.disposeBag = nil
        self.viewModel = nil
        self.cbCentralManager = nil
        self.bluetoothService = nil
    }
    func testVerifyAndProcessNextScreenError() {
        self.verifyState(state: .poweredOff,
                         errorKind: BLError.bluetoothUnavailable(reason: .poweredOff))
        self.verifyState(state: .unsupported,
                         errorKind: BLError.bluetoothUnavailable(reason: .unsupported))
        self.verifyState(state: .unknown,
                         errorKind: BLError.bluetoothUnavailable(reason: .unknown))
        self.verifyState(state: .resetting,
                         errorKind: BLError.bluetoothUnavailable(reason: .resetting))
        self.verifyState(state: .unauthorized,
                         errorKind: BLError.bluetoothUnavailable(reason: .unauthorized))
    }
    func testVerifyAndProcessNextScreenSuccess() {
        let performAction = scheduler.createObserver(Void.self)
        //
        self.cbCentralManager.setState(.poweredOn)
        //
        let nextAction = PublishSubject<Void>().asObserver()
        let input = PermissionViewModel.Input(continueButtonTrigger: nextAction)
        
        
        let output = viewModel.transform(input: input)
        output.perFormNextScreen.drive(performAction).disposed(by: self.disposeBag)
        scheduler.createHotObservable([.next(10, ())])
            .bind(to: nextAction)
            .disposed(by: self.disposeBag)
        scheduler.start()
        XCTAssertNotNil(performAction.events)
    }
    func verifyState(state: CBManagerState, errorKind: BLError) {
        let error = scheduler.createObserver(BLError.self)
        let performAction = scheduler.createObserver(Void.self)
        
        let nextAction = PublishSubject<Void>().asObserver()
        
        let input = PermissionViewModel.Input(continueButtonTrigger: nextAction)
        let output = viewModel.transform(input: input)
        self.cbCentralManager.setState(state)
        
        output.errorDidOccur.drive(error).disposed(by: self.disposeBag)
        output.perFormNextScreen.drive(performAction).disposed(by: self.disposeBag)
        
        let tap = scheduler
            .createHotObservable([
                .next(10, ())
            ])
        tap.bind(to: nextAction).disposed(by: self.disposeBag)
        
        
        
        scheduler.start()
        let expectError1: [Recorded<Event<BLError>>] = [
            .next(10, errorKind)
        ]
        
        XCTAssertEqual(error.events, expectError1)
    }
}
