import Foundation
import UIKit

class UserProfileViewModel {

    let userService: UserServices!

//    var error = Dynamic<NetworkError?>(nil)
//    var userInfo = Dynamic<UserInfo?>(nil)
//    var userAvatar = Dynamic<UIImage?>(nil)
//    var isFetchingData = Dynamic<Bool>(false)

    init(userService: UserServices) {
        self.userService = userService
    }

    func fetchUser(completion: (() -> Void)? = nil) {
//        self.isFetchingData.value = true
//        self.userService.fetchUserInfo { [unowned self]result in
//            switch result {
//            case.failure(let error):
//                self.error.value = error
//            case.success(let userInfo):
//                self.userInfo.value = userInfo
//
//            }
//            self.isFetchingData.value = false
//            self.fetchAvatarImage()
//            completion?()
//
//        }
    }
    func fetchAvatarImage(completion: (() -> Void)? = nil) {
//        guard let urlString = userInfo.value?.avatar else {
//            return
//        }
//
//        self.userService.fetchData(url: urlString) {(result) in
//            switch result {
//            case .success(let data) :
//                self.userAvatar.value = UIImage(data: data)
//            default:
//                break
//            }
//            completion?()
//        }
    }
}
