import UIKit

extension ViewControllerType where Self: UIViewController {
    static func create(viewModel: ViewModelType? = nil) -> Self {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        var vc = sb.instantiateViewController(
            withIdentifier: String(describing: self)
        ) as! Self

        if let viewModel = viewModel {
            vc.viewModel = viewModel
        }
        return vc
    }
}
