import Foundation
class UserServices {
    let networkProvider: NetworkProvider!
    static let url = URL(string: "https://anypoint.mulesoft.com/mocking/api/v1/links/6b4d76c6-59e1-462d-b0ec-a2034c899983/user-info")
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
    
    func fecthUserInfo(completion: @escaping (Result<UserInfo, NetworkError>) -> Void) {
        self.networkProvider.request(requestUrl: Self.url!) { (data, networkError) in
            
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data!)
            if let userInfo = userInfo {
                completion(.success(userInfo))
            }else {
                completion(.failure(NetworkError.noResultError))
            }
            
        }
    }
    func fetchData(url:String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        self.networkProvider.request(requestUrl: URL(string: url)!) { (data, networkError) in
            
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }else {
                completion(.failure(NetworkError.noResultError))
            }
            
        }
    }
}
