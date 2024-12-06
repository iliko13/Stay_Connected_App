import UIKit
import NetworkPackage

struct AnswerRequest: Codable {
    let text: String
}

final class QuestionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var question: Question?
    
    private let backButton = UIButton()
    private let configuration = UIImage.SymbolConfiguration(pointSize: 15)

    private let questionTextLabel = UILabel()
    private let userNameLabel = UILabel()
    private let postDateLabel = UILabel()
    
    private let networkService = NetworkPackage()
    
    private var answers: [Answer] = []
    private let tableView = UITableView()
    private let inputContainer = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupBackButton()
        
        guard let question = question else { return }
        questionTextLabel.text = question.description
        questionTextLabel.numberOfLines = 0
        questionTextLabel.font = UIFont.systemFont(ofSize: 16)
        questionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionTextLabel)
        
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
        
        fetchAnswers()
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
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        let answer = answers[indexPath.row]
        
        cell.nameLabel.text = answer.author.fullname
        cell.dateLabel.text = "12/05/2024"
        cell.commentLabel.text = answer.text
        
        return cell
    }

    @objc func sendButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        guard let questionId = question?.id else {
            print("Error: Question ID is missing")
            return
        }
        
        let answerRequest = AnswerRequest(text: text)
        
        let endpoint = "http://127.0.0.1:8000/questions/\(questionId)/answers"
        
        networkService.postDataWithToken(urlString: endpoint, modelType: AnswerRequest.self, body: answerRequest) { [weak self] (result: Result<Answer, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.answers.append(response)
                    
                    self.tableView.reloadData()
                    
                    let indexPath = IndexPath(row: self.answers.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    
                    self.textField.text = ""
                    self.textField.resignFirstResponder()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    print("Error posting answer: \(error)")
                    
                    let alert = UIAlertController(title: "Error", message: "Failed to submit your answer.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func fetchAnswers() {
        guard let questionId = question?.id else {
            print("Error: Question ID is missing")
            return
        }
        
        let endpoint = "http://127.0.0.1:8000/questions/\(questionId)/answers"
        
        networkService.fetchDataWithToken(urlString: endpoint, modelType: [Answer].self) { [weak self] (result: Result<[Answer], Error>) in
            switch result {
            case .success(let answers):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.answers = answers
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching answers: \(error)")
            }
        }
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
