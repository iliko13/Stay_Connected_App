
import UIKit



final class ProfileViewController: UIViewController {
    
    private let profileTitleLabel = UILabel()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    
    private let informationLabel = UILabel()
    private let scoreLabel = UILabel()
    private let answeredQuestionsLabel = UILabel()
    
    private let scoreValueLabel = UILabel()
    private let answeredQuestionsValueLabel = UILabel()
    
    private let logoutButton = UIButton()
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        viewModel.fetchProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetchProfile()
    }
    
    private func setupUI() {
        setupProfile()
        setupInformation()
    }
    
    private func setupProfile() {
        view.addSubview(profileTitleLabel)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        profileTitleLabel.text = "Profile"
        profileTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        profileTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        profileImageView.image = UIImage(named: "userPhoto")
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileTitleLabel.bottomAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        nameLabel.text = "John Doe"
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        emailLabel.text = "john.doe@example.com"
        emailLabel.font = UIFont.systemFont(ofSize: 15)
        emailLabel.textColor = UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupInformation() {
        view.addSubview(informationLabel)
        view.addSubview(scoreLabel)
        view.addSubview(answeredQuestionsLabel)
        view.addSubview(scoreValueLabel)
        view.addSubview(answeredQuestionsValueLabel)
        view.addSubview(logoutButton)
        
        informationLabel.text = "Information"
        informationLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 40),
            informationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        scoreLabel.text = "Score"
        scoreLabel.font = UIFont.systemFont(ofSize: 17)
        scoreLabel.textColor = UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scoreValueLabel.text = "85"
        scoreValueLabel.font = UIFont.systemFont(ofSize: 17)
        scoreValueLabel.textAlignment = .right
        scoreValueLabel.textColor = UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1)
        scoreValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 40),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreValueLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            scoreValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        answeredQuestionsLabel.text = "Answered Questions"
        answeredQuestionsLabel.font = UIFont.systemFont(ofSize: 17)
        answeredQuestionsLabel.textColor = UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1)
        answeredQuestionsLabel.translatesAutoresizingMaskIntoConstraints = false
        answeredQuestionsLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        answeredQuestionsLabel.addGestureRecognizer(tapGesture)
        
        answeredQuestionsValueLabel.text = "42"
        answeredQuestionsValueLabel.font = UIFont.systemFont(ofSize: 17)
        answeredQuestionsValueLabel.textAlignment = .right
        answeredQuestionsValueLabel.textColor = UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1)
        answeredQuestionsValueLabel.translatesAutoresizingMaskIntoConstraints = false
        answeredQuestionsValueLabel.isUserInteractionEnabled = true
        let tapGestureForValueLabel = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        answeredQuestionsValueLabel.addGestureRecognizer(tapGestureForValueLabel)
        
        NSLayoutConstraint.activate([
            answeredQuestionsLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            answeredQuestionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answeredQuestionsValueLabel.centerYAnchor.constraint(equalTo: answeredQuestionsLabel.centerYAnchor),
            answeredQuestionsValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.tintColor = UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1)
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor(red: 94/255, green: 99/255, blue: 102/255, alpha: 1), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: answeredQuestionsLabel.bottomAnchor, constant: 40),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    private func bindViewModel() {
        viewModel.onUserUpdate = { [weak self] in
            guard let self = self, let user = self.viewModel.user else { return }
            
            DispatchQueue.main.async {
                self.nameLabel.text = user.fullname
                self.emailLabel.text = user.email
                self.scoreValueLabel.text = "\(user.rating)"
                self.answeredQuestionsValueLabel.text = "\(user.answers.count)"
            }
        }
        
        viewModel.onError = { errorMessage in
            print("Error: \(errorMessage)")
        }
    }
    
    @objc func labelTapped() {
        navigationController?.pushViewController(AnsweredQuestionsViewController(), animated: true)
    }
    
    @objc func logoutButtonTapped() {
        viewModel.logout()
        navigationController?.pushViewController(LoginVC(), animated: true)
    }
}
