import Foundation
import RxSwift
import RxCocoa

class PermissionViewModel: ViewModelType {
    struct Output {
        let errorDidOccur : Driver<BLError>
        let perFormNextScreen : Driver<Void>
    }
    struct Input {
        let continueButtonTrigger: Observable<Void>
    }

    var input: Input?
    var output: Output?
    var navigator: PermissionsNavigator!
    
    private let disposeBag = DisposeBag()
    private let errorDidOccur = PublishSubject<BLError>()
    private let perFormNextScreen = PublishSubject<Void>()
    
    init(navigator: PermissionsNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        self.input = input
        input.continueButtonTrigger
            .flatMap{ self.verifyAndMapErrorIfNeed() }
            .subscribe(onNext: { (error) in
                if let  _error = error {
                    self.errorDidOccur.onNext((_error))
                } else {
                    self.navigator.routed(router: .tabBar)
                }
            }).disposed(by: self.disposeBag)
        
        self.output = Output(
            errorDidOccur: self.errorDidOccur.asDriver(onErrorJustReturn: BLError.bluetoothUnavailable(reason: .unknown)),
            perFormNextScreen: self.perFormNextScreen.asDriver(onErrorJustReturn: ())
        )
        return self.output!
    }
    func verifyAndMapErrorIfNeed() -> Observable<BLError?> {
        return BluetoothService.shared.state.map { state -> BLError? in
            var error: BLError?
            switch state {
            case .poweredOn:
                error = nil
            case .poweredOff:
                error = .bluetoothUnavailable(reason: .poweredOff)
            case.unauthorized:
                error = .bluetoothUnavailable(reason: .unauthorized)
            case.resetting:
                error = .bluetoothUnavailable(reason: .resetting)
            case.unsupported:
                error = .bluetoothUnavailable(reason: .unsupported)
            default:
                error = .bluetoothUnavailable(reason: .unknown)
            }
            return error
        }
    }
}
