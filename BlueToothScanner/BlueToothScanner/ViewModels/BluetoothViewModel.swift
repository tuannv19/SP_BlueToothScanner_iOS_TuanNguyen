import  CoreBluetooth
import RxSwift
import RxCocoa
class BluetoothViewModel: ViewModelType{
    let disposeBag = DisposeBag()
    struct Input {
        var isScanning : Observable<Bool>
        var itemSelected: Observable<IndexPath>
    }
    
    struct Output {
        var bluetoothState: Driver<String>
        var isEnableSwitchButton: Driver<Bool>
        var isScanning : Driver<Bool>
        var peripherals: Driver<[PeripheralModel]>
    }
    
    //    private var currentState: Observable<String>!
    
    // MARK: - Public Properties
    var numberOfPeripheralModel: Int {
        return  0//self.peripherals.value.count
    }
    
    // MARK: - Dynamic Properties
    private var peripherals = BehaviorSubject<[PeripheralModel]>(value: [])
    
    // MARK: - Bluetooth
    let bluetoothService = BluetoothService.shared
    
    private var peripheralInfos = [PeripheralInfo]()
    
    var filterModel = FilterModel()
    
    init() {
        self.bluetoothService
            .peripheralsDidReceive.map { device in
                self.addOrUpdatePeripheralIfNeed(peripheralInfo: device)
        }.subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func transform(input: Input) -> Output {
        input.isScanning.subscribe(onNext: { startScan in
            if startScan == true {
                self.bluetoothService.startScan()
            }else {
                self.bluetoothService.stopScan()
            }
            
        }).disposed(by: self.disposeBag)
        
        
        let stateObservable = Observable.merge(
            bluetoothService.state, bluetoothService.bluetoothStateDidReceive
        ).share()
        
        let  currentState =   stateObservable.map { state -> String in
            var currentState: String
            switch state {
            case .poweredOff:
                currentState = "poweredOff"
            case .poweredOn:
                currentState = "poweredOn"
            case.unauthorized:
                currentState = "unauthorized"
            default:
                currentState = "unknown"
            }
            return currentState
        }
        
        let isEnableSwitchButton = stateObservable.map { state -> Bool in
            guard state == .poweredOn else {
                return false
            }
            return true
        }
        return Output(
            bluetoothState: currentState.asDriver(onErrorJustReturn: ""),
            isEnableSwitchButton: isEnableSwitchButton.asDriver(onErrorJustReturn: false),
            isScanning: input.isScanning.asDriver(onErrorJustReturn: false),
            peripherals: self.peripherals.asDriver(onErrorJustReturn: [])
        )
    }
}

extension BluetoothViewModel {
    func applyNewFilter(filterModel: FilterModel) {
        self.filterModel = filterModel
        self.peripherals.onNext(self.applyFilter())
    }
    
    internal func addOrUpdatePeripheralIfNeed(peripheralInfo: PeripheralInfo) {
        
        //check if Peripheral had existing
        guard let indexOfExistPeripheral = self.peripheralInfos
            .firstIndex(where: { (model: PeripheralInfo) -> Bool in
                model.0.identifier.uuidString == peripheralInfo.0.identifier.uuidString
            }) as Int? else {
                
                //if not exit just add and update UI
                self.peripheralInfos.append(peripheralInfo)
                //                self.peripherals.value = self.applyFilter()
                return
        }
        
        //update peripheral data
        // RSSI
        self.peripheralInfos[indexOfExistPeripheral] = peripheralInfo
        
        //filter data
        //                self.peripherals.value = self.applyFilter()
        self.peripherals.onNext(self.applyFilter())
        
        
    }
    
    internal func applyFilter() -> [PeripheralModel] {
        let v = self.peripheralInfos.filter { (peripheralInfo) -> Bool in
            if self.filterModel.filterEmptyName {
                guard peripheralInfo.0.name != nil else {
                    return false
                }
            }
            if self.filterModel.filterRSSI {
                if let rssiFrom = filterModel.rssiFrom {
                    guard rssiFrom < peripheralInfo.2.intValue else {
                        return false
                    }
                }
                if let rssiToo = filterModel.rssiTo {
                    guard rssiToo > peripheralInfo.2.intValue else {
                        return false
                    }
                }
            }
            return true
        }
        
        return v.compactMap { (info: PeripheralInfo) -> PeripheralModel? in
            var model = PeripheralModel(info: info)
            if model?.name == nil {
                model?.name = info.0.identifier.uuidString
            }
            return model
        }
    }
}
