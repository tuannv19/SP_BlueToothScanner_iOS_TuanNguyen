import UIKit

protocol Coordinator {
    associatedtype Router
    var navigationController: UINavigationController? { get set }
    func routed(router: Router)
}
