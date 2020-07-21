import Foundation
import UIKit

class UserProfileViewModel {
    let userService: UserServices!

    var userInfoDidChange: ((UserInfo) -> Void)?
    var avatarDidChange: ((UIImage) -> Void)?
    var errorHasOccur: ((Error) -> Void)?
    var isFetchDataDidChange: ((Bool) -> Void)?

    var isFetchingData: Bool? {
        didSet {
            DispatchQueue.main.async {
                self.isFetchDataDidChange?(self.isFetchingData!)
            }
        }
    }

    var userInfo: UserInfo? {
        didSet {
            DispatchQueue.main.async {
                self.userInfoDidChange?(self.userInfo!)
            }
            self.fetchAvatarImage()
        }
    }
    var userAvatar: UIImage? {
        didSet {
            if let userAvatar = self.userAvatar {
                DispatchQueue.main.async {
                    self.avatarDidChange?(userAvatar)
                }
            }
        }
    }
    var error: Error? {
        didSet {
            self.errorHasOccur?(error!)
        }
    }

    init(userService: UserServices) {
        self.userService = userService
    }

    func fetchUser(completion: (() -> Void)? = nil) {
        self.isFetchingData = true

        self.userService.fetchUserInfo { [unowned self]result in
            switch result {
            case.failure(let error):
                self.error = error
            case.success(let userInfo):
                self.userInfo = userInfo
                self.isFetchingData = false
            }
            completion?()

        }
    }
    func fetchAvatarImage(completion: (() -> Void)? = nil) {
        guard let urlString = userInfo?.avatar else {
            return
        }

        self.userService.fetchData(url: urlString) { [unowned self](result) in
            switch result {
            case .success(let data) :
                self.userAvatar = UIImage(data: data)
            default:
                break
            }
            completion?()
        }
    }
}
