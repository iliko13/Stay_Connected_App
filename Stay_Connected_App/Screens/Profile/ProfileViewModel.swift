
import Foundation
import KeychainSwift
import NetworkPackage

final class ProfileViewModel {
    private let networkService: NetworkPackage
    private let keychain: KeychainSwift
    
    var user: UserResponseModel? {
        didSet {
            onUserUpdate?()
        }
    }
    
    var onUserUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(networkService: NetworkPackage = NetworkPackage(), keychain: KeychainSwift = KeychainSwift()) {
        self.networkService = networkService
        self.keychain = keychain
    }
    
    func fetchProfile() {
        networkService.fetchDataWithToken(urlString: "http://127.0.0.1:8000/user/profile/", modelType: UserResponseModel.self) { [weak self] (result: Result<UserResponseModel, Error>) in
            switch result {
            case .success(let userResponse):
                self?.user = userResponse
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        KeychainHelper.deleteTokens()
    }
}
