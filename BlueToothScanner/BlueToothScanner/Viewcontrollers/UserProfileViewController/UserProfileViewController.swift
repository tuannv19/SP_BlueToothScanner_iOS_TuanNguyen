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

    let viewModel = UserProfileViewModel(
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
        self.viewModel.userInfoDidChange = { [unowned self] user in
            self.nameLabel.text = user.name
            self.userNameLabel.text = user.username
            self.companyLabel.text = user.company.name
            self.phoneLabel.text = user.phone
            self.addressLabel.text = user.getFullAddress()
        }
        self.viewModel.isFetchDataDidChange = { [unowned self] isFetchingData in
            if isFetchingData {
                self.stackView.isHidden = true
                self.loadingIndicator.startAnimating()
            } else {
                self.stackView.isHidden = false
                self.loadingIndicator.stopAnimating()
            }
        }

        self.viewModel.errorHasOccur = { [unowned self] error in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.showAlert(title: "Error", message: error.localizedDescription)
                self.stackView.isHidden = true
            }
        }
        self.viewModel.avatarDidChange = { [unowned self] image in
            self.avatarImageView.image = image
        }

        self.viewModel.fetchUser()
    }

    func setupNavigationBarButton() {
        let rightBtn = UIBarButtonItem(title: "Reload",
                                       style: .plain,
                                       target: self, action: #selector(rightBarButtonCLick))
        self.navigationItem.rightBarButtonItem = rightBtn
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
