import UIKit
import NetworkPackage

class SignUpVC: UIViewController {
    
    private let backButton = UIButton()
    private let viewModel = SignUpViewModel()
    
    private var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Sign up", color: .black, isBold: true, size: 30)
        return label
    }()
    
    private var fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Full Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
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
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
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
    
    private let confirmPasswordTextField: UITextField = {
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
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureWith(title: "Sign Up", fontSize: 16, titleColor: .white, backgroundColor: UIColor(hex: "#4E53A2"))
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupPasswordFieldIcons()
        viewModel.showAlert = { [weak self] message in
            self?.showAlert(message: message)
        }
        
        viewModel.didSignUp = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.showAlert(message: "Sign Up Successful!")
            }
        }
        
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
    }
    
    private func setupUI() {
        addingViews()
        setupConstraints()
        setupBackButton()
    }
    
    private func addingViews() {
        view.addSubview(loginLabel)
        view.addSubview(signupButton)
        view.addSubview(fullnameTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            fullnameTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 50),
            fullnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullnameTextField.widthAnchor.constraint(equalToConstant: 342),
            fullnameTextField.heightAnchor.constraint(equalToConstant: 59),
            
            usernameTextField.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor, constant: 30),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalToConstant: 342),
            usernameTextField.heightAnchor.constraint(equalToConstant: 59),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 342),
            passwordTextField.heightAnchor.constraint(equalToConstant: 59),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 342),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 59),
            
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.widthAnchor.constraint(equalToConstant: 342),
            signupButton.heightAnchor.constraint(equalToConstant: 59),
        ])
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
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
        
        let confirmPadlockIcon = UIImageView(image: UIImage(systemName: "lock"))
        confirmPadlockIcon.tintColor = .black
        
        confirmPasswordTextField.leftView = confirmPadlockIcon
        confirmPasswordTextField.leftViewMode = .always
        
        let confirmEyeIcon = UIButton(type: .custom)
        confirmEyeIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        confirmEyeIcon.tintColor = .black
        confirmEyeIcon.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        confirmEyeIcon.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        
        confirmPasswordTextField.rightView = confirmEyeIcon
        confirmPasswordTextField.rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        
        if passwordTextField.isSecureTextEntry {
            (passwordTextField.rightView as? UIButton)?.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            (passwordTextField.rightView as? UIButton)?.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
    
    @objc private func toggleConfirmPasswordVisibility() {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        
        if confirmPasswordTextField.isSecureTextEntry {
            (confirmPasswordTextField.rightView as? UIButton)?.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            (confirmPasswordTextField.rightView as? UIButton)?.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
    
    @objc private func handleSignup() {
        viewModel.validateAndSignUp(fullname: fullnameTextField.text,
                                    email: usernameTextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordTextField.text)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
