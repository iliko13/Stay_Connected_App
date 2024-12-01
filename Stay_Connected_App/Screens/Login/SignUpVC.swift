//
//  SignUpVC.swift
//  Stay_Connected
//
//  Created by iliko on 11/29/24.
//

import UIKit

class SignUpVC: UIViewController {
    
    private let backButton = UIButton()
    private let configuration = UIImage.SymbolConfiguration(pointSize: 15)
    
    private var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Sign up", color: .black, isBold: true, size: 30)
        return label
    }()
    
    private var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Full Name", color: .black, isBold: false, size: 12)
        label.textColor = UIColor(hex: "5E6366")
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
        label.configureCustomText(text: "Enter Password", color: .black, isBold: false, size: 12)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Confirm Password", color: .black, isBold: false, size: 12)
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
        textField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()
    
    private let fullnameTextField: UITextField = {
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
            string: "Name",
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
    
    private let viewModel = LiderboardVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupPasswordFieldIcons()
    }
    
    private func setupUI() {
        addingViews()
        setupConstraints()
        setupBackButton()
    }
    
    private func addingViews() {
        view.addSubview(loginLabel)
        view.addSubview(signupButton)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(fullnameTextField)
        view.addSubview(fullnameLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(confirmPasswordLabel)
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: configuration), for: .normal)
        backButton.tintColor = UIColor(hex: "090A0A", alpha: 1.0)
        backButton.addAction(UIAction(handler: { [weak self] action in self?.backFunc()}), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func backFunc() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            fullnameLabel.bottomAnchor.constraint(equalTo: fullnameTextField.topAnchor, constant: -8),
            fullnameLabel.leadingAnchor.constraint(equalTo: fullnameTextField.leadingAnchor),
            
            fullnameTextField.widthAnchor.constraint(equalToConstant: 342),
            fullnameTextField.heightAnchor.constraint(equalToConstant: 59),
            fullnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullnameTextField.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -45),
            
            emailLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -8),
            emailLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            
            usernameTextField.widthAnchor.constraint(equalToConstant: 342),
            usernameTextField.heightAnchor.constraint(equalToConstant: 59),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 170),
            
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: 342),
            passwordTextField.heightAnchor.constraint(equalToConstant: 59),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 45),
            
            confirmPasswordLabel.bottomAnchor.constraint(equalTo: confirmPasswordTextField.topAnchor, constant: -8),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 342),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 59),
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 45),
            
            signupButton.widthAnchor.constraint(equalToConstant: 342),
            signupButton.heightAnchor.constraint(equalToConstant: 59),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -109),
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
}
