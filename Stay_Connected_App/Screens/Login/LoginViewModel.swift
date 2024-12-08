
import Foundation
import KeychainSwift
import NetworkPackage

class LoginViewModel {

    var email: String = ""
    var password: String = ""
    
    var isLoginEnabled: Bool {
        return !email.isEmpty && !password.isEmpty
    }

    var loginSuccess: ((LoginResponse) -> Void)?
    var loginFailure: ((Error) -> Void)?
    var showValidationError: (() -> Void)?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func login() {
        guard isLoginEnabled else {
            showValidationError?()
            return
        }
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        networkService.postData(
            to: "http://127.0.0.1:8000/api/token/",
            modelType: LoginResponse.self,
            requestBody: loginRequest
        ) { result in
            switch result {
            case .success(let loginResponse):
                self.loginSuccess?(loginResponse)
            case .failure(let error):
                self.loginFailure?(error)
            }
        }
    }
    
    func storeTokens(accessToken: String, refreshToken: String) {
        KeychainHelper.saveAccessToken(accessToken)
        KeychainHelper.saveRefreshToken(refreshToken)
    }
}
