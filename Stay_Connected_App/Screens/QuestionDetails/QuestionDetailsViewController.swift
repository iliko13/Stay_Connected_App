import UIKit

final class QuestionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var question: APIQuestion?
    
    private let backButton = UIButton()
    private let configuration = UIImage.SymbolConfiguration(pointSize: 15)

    private let questionTextLabel = UILabel()
    private let userNameLabel = UILabel()
    private let postDateLabel = UILabel()
    
    private var profiles: [(String, String, String, Bool)] = [
        ("John Doe", "11/23/2024", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", false),
        ("Jane Smith", "11/24/2024", "Quisque velit nisi, pretium ut lacinia in.", false),
        ("Alex Johnson", "11/25/2024", "Pellentesque in ipsum id orci porta dapibus.", false)
    ]
    
    private var answers: [Answer]?
    private let tableView = UITableView()
    private let inputContainer = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupBackButton()
        
        answers = question?.answers
        
        guard let question = question else { return }

        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "questionCell")
        
        questionTextLabel.text = question.description
        questionTextLabel.numberOfLines = 0
        questionTextLabel.font = UIFont.systemFont(ofSize: 16)
        questionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionTextLabel)
        
        // Format the createdAt date
        let formattedDate = formatDateString(question.createdAt)
        userNameLabel.text = "@\(question.author.fullname) asked on \(formattedDate)"
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
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        let profile = profiles[indexPath.row]
        
        cell.nameLabel.text = profile.0
        cell.dateLabel.text = profile.1
        cell.commentLabel.text = profile.2
        
        if profile.3 {
            cell.acceptedLabel.text = "Accepted ✓"
            cell.acceptedLabel.textColor = .green
        } else {
            cell.acceptedLabel.text = ""
            cell.acceptedLabel.textColor = .gray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let profileStatus = profiles[indexPath.row].3
        
        if profileStatus {
            let rejectAction = UITableViewRowAction(style: .normal, title: "Reject") { (action, indexPath) in
                self.profiles[indexPath.row].3 = false
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            rejectAction.backgroundColor = .red
            return [rejectAction]
        } else {
            let acceptAction = UITableViewRowAction(style: .normal, title: "Accept") { (action, indexPath) in
                self.profiles[indexPath.row].3 = true
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            acceptAction.backgroundColor = .green
            return [acceptAction]
        }
    }
    
    @objc func sendButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        profiles.append(("New User", "12/01/2024", text, false))
        
        tableView.reloadData()
        
        let indexPath = IndexPath(row: profiles.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
