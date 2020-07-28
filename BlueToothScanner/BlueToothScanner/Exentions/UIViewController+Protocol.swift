protocol ViewControllerType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! {get set }
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
