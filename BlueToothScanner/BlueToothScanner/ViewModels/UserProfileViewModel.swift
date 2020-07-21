import Foundation
import UIKit

class UserProfileViewModel {
    let userSevice: UserServices!

    var userInfoDidChange: ((UserInfo) -> Void)?
    var avartarDidChange: ((UIImage) -> Void)?
    var errorHasOcur: ((Error) -> Void)?
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
    var userAvartar: UIImage? {
        didSet {
            if let userAvartar = self.userAvartar {
                DispatchQueue.main.async {
                    self.avartarDidChange?(userAvartar)
                }
            }
        }
    }
    var error: Error? {
        didSet {
            self.errorHasOcur?(error!)
        }
    }

    init(userService: UserServices) {
        self.userSevice = userService
    }

    func fetchUser(completion: (() -> Void)? = nil) {
        self.isFetchingData = true

        self.userSevice.fecthUserInfo { [unowned self]result in
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

        self.userSevice.fetchData(url: urlString) { [unowned self](result) in
            switch result {
            case .success(let data) :
                self.userAvartar = UIImage(data: data)
            default:
                break
            }
            completion?()
        }
    }
}
