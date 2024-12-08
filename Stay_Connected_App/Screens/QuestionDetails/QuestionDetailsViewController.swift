import UIKit

final class QuestionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var viewModel: QuestionDetailsViewModel
    
    private let backButton = UIButton()
    private let configuration = UIImage.SymbolConfiguration(pointSize: 15)

    private let questionTextLabel = UILabel()
    private let userNameLabel = UILabel()
    private let tableView = UITableView()
    private let inputContainer = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton()
    
    init(viewModel: QuestionDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()

            }
        }
        
        viewModel.showAlert = { [weak self] message in
            self?.showAlert(message: message)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupBackButton()
        
        questionTextLabel.text = viewModel.question.description
        questionTextLabel.numberOfLines = 0
        questionTextLabel.font = UIFont.systemFont(ofSize: 16)
        questionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionTextLabel)
        
        let formattedDate = formatDateString(viewModel.question.createdAt)
        userNameLabel.text = "@\(viewModel.question.author.fullname) asked on \(formattedDate)"
        userNameLabel.font = UIFont.systemFont(ofSize: 12)
        userNameLabel.textColor = .gray
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userNameLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "questionCell")
        self.view.addSubview(tableView)
        
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(inputContainer)
        
        textField.placeholder = "Type your answer here"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(textField)
        
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .gray
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = sendButton
        textField.rightViewMode = .always
        
        NSLayoutConstraint.activate([
            questionTextLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            questionTextLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            userNameLabel.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),
            
            inputContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            inputContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            inputContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            inputContainer.heightAnchor.constraint(equalToConstant: 50),
            
            textField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
            textField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 55),
            textField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10)
        ])
        
        viewModel.fetchAnswers()
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy 'at' HH:mm"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        let answer = viewModel.answers[indexPath.row]
        
        cell.nameLabel.text = answer.author?.fullname
        cell.dateLabel.text = "12/05/2024"
        cell.commentLabel.text = answer.text
        cell.isCorrect = answer.isCorrect ?? false
        
        return cell
    }

    @objc func sendButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        viewModel.postAnswer(text: text)
        
        textField.text = ""
        textField.resignFirstResponder()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
}


extension QuestionDetailsViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let answer = viewModel.answers[indexPath.row]
        
        if answer.isCorrect == true {
            let rejectAction = UIContextualAction(style: .destructive, title: "Reject") { (action, view, completionHandler) in
                self.viewModel.rejectAnswer(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            rejectAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [rejectAction])
        }
        
        let acceptAction = UIContextualAction(style: .normal, title: "Accept") { (action, view, completionHandler) in
            self.viewModel.acceptAnswer(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        acceptAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [acceptAction])
    }
}
