import UIKit

class UserProfileViewController: UIViewController, ViewControllerType {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!

    var viewModel: UserProfileViewModel! = UserProfileViewModel(
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
        self.viewModel.userInfo.bind({ [weak self] (userInfo) in
            guard let userInfo = userInfo, let self = self else {
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

        self.viewModel.error.bind({ [weak self] (error) in
            guard let error = error, let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
//                self.showAlert(title: "Error", message: error.localizedDescription)
                
                self.stackView.isHidden = true
            }
        })
        self.viewModel.isFetchingData.bind({[weak self] isFetchData in
            guard let self = self else {
                return
            }
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

        self.viewModel.userAvatar.bind({ [weak self]image in
            guard let self = self else {
                return
            }
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
