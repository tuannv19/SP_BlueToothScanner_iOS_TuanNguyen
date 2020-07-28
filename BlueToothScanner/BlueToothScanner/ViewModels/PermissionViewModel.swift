import Foundation
import RxSwift
import RxCocoa

class PermissionViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let errorDidOccur = PublishSubject<BLError>()
    private let perFormNextScreen = PublishSubject<Void>()
    
    struct Output {
        let errorDidOccur : Driver<BLError>
        let perFormNextScreen : Driver<Void>
    }
    struct Input {
        let continueButtonTrigger: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        input.continueButtonTrigger
            .flatMap{ self.verifyAndProcessNextScreen() }
            .subscribe(onNext: { result in
                switch result{
                case .success:
                    self.perFormNextScreen.onNext(())
                case.failure(let error):
                    self.errorDidOccur.onNext(error)
                }
            }).disposed(by: self.disposeBag)
        
        return Output(
            errorDidOccur: self.errorDidOccur
                .asDriver(onErrorJustReturn: BLError.bluetoothUnavailable(reason: .unknown)),
            perFormNextScreen: self.perFormNextScreen.asDriver(onErrorJustReturn: ())
        )
    }
    func verifyAndProcessNextScreen() -> Single<Result<Void, BLError>> {
        return Single<Result<Void, BLError>>.create { (single)  in
            var error: BLError?
            switch BluetoothService.shared.state {
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
            if let error = error {
                single(.success(.failure(error)))
            }else {
                single(.success(.success(())))
            }
            return Disposables.create()
        }
    }
}
