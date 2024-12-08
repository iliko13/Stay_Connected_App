import UIKit
import KeychainSwift
import NetworkPackage

class LoginVC: UIViewController {
    
    private var viewModel: LoginViewModel!
    
    private var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Log In", color: .black, isBold: true, size: 30)
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Email", color: .black, isBold: false, size: 12)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Password", color: .black, isBold: false, size: 12)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private let forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forget Password?", for: .normal)
        button.setTitleColor(UIColor(hex: "#4E53A2"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.contentHorizontalAlignment = .trailing
        return button
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private var newToStayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "New To StayConnected?", color: .black, isBold: false, size: 12)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(hex: "#4E53A2"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.contentHorizontalAlignment = .trailing
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureWith(title: "Log In", fontSize: 16, titleColor: .white, backgroundColor: UIColor(hex: "#4E53A2"))
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Initialization and Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupViewModel()
        setupPasswordFieldIcons()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupUI() {
        addingViews()
        setupConstraints()
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
    }
    
    private func setupViewModel() {
        viewModel = LoginViewModel(networkService: NetworkPackage())
    }
    
    private func setupBindings() {
        viewModel.loginSuccess = { [weak self] loginResponse in
            self?.storeTokens(accessToken: loginResponse.access, refreshToken: loginResponse.refresh)
            self?.navigateToDashboard()
        }
        
        viewModel.loginFailure = { [weak self] error in
            self?.showLoginError(error: error)
        }
        
        viewModel.showValidationError = { [weak self] in
            self?.showValidationError()
        }
    }
    
    private func addingViews() {
        view.addSubview(loginLabel)
        view.addSubview(loginButton)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(forgetPasswordButton)
        view.addSubview(newToStayLabel)
        view.addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 123),
            
            emailLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -8),
            emailLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            
            usernameTextField.widthAnchor.constraint(equalToConstant: 342),
            usernameTextField.heightAnchor.constraint(equalToConstant: 59),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 80),
            
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            
            forgetPasswordButton.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: 342),
            passwordTextField.heightAnchor.constraint(equalToConstant: 59),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 45),
            
            newToStayLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            newToStayLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            
            signUpButton.centerYAnchor.constraint(equalTo: newToStayLabel.centerYAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            loginButton.widthAnchor.constraint(equalToConstant: 342),
            loginButton.heightAnchor.constraint(equalToConstant: 59),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -109),
        ])
    }
    
    private func setupPasswordFieldIcons() {
        let padlockIcon = UIImageView(image: UIImage(systemName: "lock"))
        padlockIcon.tintColor = .black
        
        passwordTextField.leftView = padlockIcon
        passwordTextField.leftViewMode = .always
        
        let eyeIcon = UIButton(type: .custom)
        eyeIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        eyeIcon.tintColor = .black
        eyeIcon.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        eyeIcon.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        passwordTextField.rightView = eyeIcon
        passwordTextField.rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        
        let eyeButton = passwordTextField.rightView as? UIButton
        let eyeImage = passwordTextField.isSecureTextEntry ? UIImage(systemName: "eye.slash.fill") : UIImage(systemName: "eye.fill")
        eyeButton?.setImage(eyeImage, for: .normal)
    }
    
    @objc private func navigateToSignUp() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.email = usernameTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        
        viewModel.login()
    }
    
    // MARK: - Helpers
    private func showLoginError(error: Error) {
        let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showValidationError() {
        let alert = UIAlertController(title: "Validation Error", message: "Please fill in both email and password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func storeTokens(accessToken: String, refreshToken: String) {
        KeychainHelper.saveAccessToken(accessToken)
        KeychainHelper.saveRefreshToken(refreshToken)
    }
    
    private func navigateToDashboard() {
        DispatchQueue.main.async {
            let homeVC = TabBarController()
            let navController = UINavigationController(rootViewController: homeVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
}
