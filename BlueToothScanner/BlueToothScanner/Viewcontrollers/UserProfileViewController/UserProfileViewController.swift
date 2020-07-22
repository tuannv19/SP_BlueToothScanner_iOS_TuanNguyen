import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!

    internal let viewModel = UserProfileViewModel(
        userService: UserServices(networkProvider: NetworkProvider())
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBarButton()
        self.bindViewModel()
    }
    func setupView() {
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
        self.title = "Profile"
    }

    func bindViewModel() {
        self.viewModel.userInfo.bind({ (userInfo) in
            guard let userInfo = userInfo else {
                return
            }
            DispatchQueue.main.async {
                self.nameLabel.text = userInfo.name
                self.userNameLabel.text = userInfo.username
                self.companyLabel.text = userInfo.company.name
                self.phoneLabel.text = userInfo.phone
                self.addressLabel.text = userInfo.getFullAddress()
            }
        })

        self.viewModel.error.bind({ (error) in
            guard let error = error else {
                return
            }
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.showAlert(title: "Error", message: error.localizedDescription)
                self.stackView.isHidden = true
            }
        })
        self.viewModel.isFetchingData.bind({ isFetchData in
            DispatchQueue.main.async {
                if isFetchData {
                    self.stackView.isHidden = true
                    self.loadingIndicator.startAnimating()
                } else {
                    self.stackView.isHidden = false
                    self.loadingIndicator.stopAnimating()
                }
            }
        })

        self.viewModel.userAvatar.bind({ image in
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        })
        self.viewModel.fetchUser()
    }

    func setupNavigationBarButton() {
        let rightButton = UIBarButtonItem(title: "Reload",
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightBarButtonCLick))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    @objc func  rightBarButtonCLick() {
        self.viewModel.fetchUser()
    }
}
// MARK: - Factory
extension UserProfileViewController {
    static func create() -> UserProfileViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(
            withIdentifier: "UserProfileViewController"
            ) as! UserProfileViewController
        return vc
    }
}
