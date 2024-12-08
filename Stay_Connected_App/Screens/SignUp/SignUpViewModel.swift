
import UIKit
import NetworkPackage

class SignUpViewModel {
    
    var showAlert: ((String) -> Void)?
    var didSignUp: (() -> Void)?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkPackage()) {
        self.networkService = networkService
    }
    
    func validateAndSignUp(fullname: String?, email: String?, password: String?, confirmPassword: String?) {
        
        guard let fullname = fullname, !fullname.isEmpty else {
            DispatchQueue.main.async {
                self.showAlert?("Full Name is required.")
            }
            return
        }
        
        guard let email = email, !email.isEmpty else {
            DispatchQueue.main.async {
                self.showAlert?("Email is required.")
            }
            return
        }
        
        guard let password = password, !password.isEmpty else {
            DispatchQueue.main.async {
                self.showAlert?("Password is required.")
            }
            return
        }
        
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            DispatchQueue.main.async {
                self.showAlert?("Please confirm your password.")
            }
            return
        }
        
        if password != confirmPassword {
            DispatchQueue.main.async {
                self.showAlert?("Passwords do not match.")
            }
            return
        }
        
        let requestBody = SignupRequest(email: email, fullname: fullname, password: password)
        
        networkService.postData(to: "http://127.0.0.1:8000/user/register/", modelType: SignupResponse.self, requestBody: requestBody) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.didSignUp?()
                }
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let data = (error as NSError).userInfo["data"] as? Data {
            do {
                let decoder = JSONDecoder()
                let errorResponse = try decoder.decode(SignupErrorResponse.self, from: data)
                
                var errorMessage = "Please fix the following errors:\n"
                if let passwordErrors = errorResponse.password {
                    errorMessage += "Password issues: \n" + passwordErrors.joined(separator: "\n") + "\n"
                }
                
                DispatchQueue.main.async {
                    self.showAlert?(errorMessage)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert?("An unexpected error occurred. Please try again.")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert?(error.localizedDescription)
            }
        }
    }
}
