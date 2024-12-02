//
//  AddQuestionViewController.swift
//  Stay_Connected_App
//
//  Created by iliko on 12/1/24.
//

import UIKit

class AddQuestionViewController: UIViewController, UITextFieldDelegate {

    private let subjectField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let tagField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your question here"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    private let tags = ["iOS", "Frontend", "Backend", "SwiftUI", "UIKit", "Python"]

    private let tagButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()

        navigationItem.title = "Add Question"

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = cancelButton

        descriptionTextField.delegate = self

        setUpLeftViewForTextField(subjectField, label: "Subject:")
        setUpLeftViewForTextField(tagField, label: "Tag:")

        descriptionTextField.rightView = sendButton
        descriptionTextField.rightViewMode = .always
    }

    private func setupUI() {
        view.addSubview(subjectField)
        view.addSubview(descriptionTextField)
        view.addSubview(tagField)
        view.addSubview(tagButtonsStackView)

        createTagButtons()

        NSLayoutConstraint.activate([
            subjectField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subjectField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            subjectField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),

            tagField.topAnchor.constraint(equalTo: subjectField.bottomAnchor, constant: 3),
            tagField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            tagField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),

            tagButtonsStackView.topAnchor.constraint(equalTo: tagField.bottomAnchor, constant: 10),
            tagButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionTextField.topAnchor.constraint(equalTo: tagButtonsStackView.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func createTagButtons() {
        for tag in tags {
            let button = UIButton(type: .system)
            button.setTitle(tag, for: .normal)
            button.backgroundColor = UIColor(hex: "#EEF2FF")
            button.setTitleColor(UIColor(hex: "#4F46E5"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.sizeToFit()
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
            tagButtonsStackView.addArrangedSubview(button)
        }
    }

    private func setUpLeftViewForTextField(_ textField: UITextField, label: String) {
        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.text = label
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textColor = .gray

        textField.leftView = leftLabel
        textField.leftViewMode = .always
    }

    @objc private func sendButtonTapped() {
        guard let text = descriptionTextField.text, !text.isEmpty else {
            return
        }
        print("Send button tapped with text: \(text)")
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func tagButtonTapped(_ sender: UIButton) {
        guard let tag = sender.title(for: .normal) else { return }
        print("Tag \(tag) tapped")
    }

    // MARK: - UITextFieldDelegate Methods (Optional)

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





