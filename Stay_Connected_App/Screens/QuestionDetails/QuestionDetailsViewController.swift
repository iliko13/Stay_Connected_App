//
//  QuestionDetailsViewController.swift
//  Stay_Connected
//
//  Created by Sandro Maraneli on 01.12.24.
//

import UIKit

final class QuestionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    private let questionText = "VoiceOver is a central part of Apple's accessibility system, to the point not accessible to other accessibility systems in iOS?"
    private let userName = "@userNameHere"
    private let postDate = "Monday, 9 May 2024"
    
    private var profiles: [(String, String, String, Bool)] = [
        ("John Doe", "11/23/2024", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", false),
        ("Jane Smith", "11/24/2024", "Quisque velit nisi, pretium ut lacinia in.", false),
        ("Alex Johnson", "11/25/2024", "Pellentesque in ipsum id orci porta dapibus.", false)
    ]
    
    private let tableView = UITableView()
    private let inputContainer = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "questionCell")
        
        let questionLabel = UILabel()
        questionLabel.text = questionText
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(questionLabel)
        
        let userLabel = UILabel()
        userLabel.text = "\(userName) asked on \(postDate)"
        userLabel.font = UIFont.systemFont(ofSize: 12)
        userLabel.textColor = .gray
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userLabel)
        
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
            questionLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            userLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            userLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            userLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 20),
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
}
