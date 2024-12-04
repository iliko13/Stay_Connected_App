//
//  AddQuestionViewController.swift
//  Stay_Connected_App
//
//  Created by iliko on 12/1/24.
//

import UIKit

class AddQuestionViewController: UIViewController, UITextFieldDelegate {
    
    private var tagList: [Technology] = []


    private let subjectField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter Subject"
        return textField
    }()
    
    private let tagField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter Tag"
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
    
    private lazy var addingTagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddTagCellForTagsInput.self, forCellWithReuseIdentifier: AddTagCellForTagsInput.identifier)
        return collectionView
    }()
    
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddTagCell.self, forCellWithReuseIdentifier: AddTagCell.identifier)
        return collectionView
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
        view.addSubview(tagsCollectionView)
        view.addSubview(addingTagsCollectionView)
        
        NSLayoutConstraint.activate([
            subjectField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subjectField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subjectField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tagField.topAnchor.constraint(equalTo: subjectField.bottomAnchor, constant: 12),
            tagField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addingTagsCollectionView.topAnchor.constraint(equalTo: tagField.topAnchor, constant: 3),
            addingTagsCollectionView.leadingAnchor.constraint(equalTo: tagField.leadingAnchor, constant: 40),
            addingTagsCollectionView.trailingAnchor.constraint(equalTo: tagField.trailingAnchor, constant: -3),
            addingTagsCollectionView.bottomAnchor.constraint(equalTo: tagField.bottomAnchor, constant: -3),
            
            
            tagsCollectionView.topAnchor.constraint(equalTo: tagField.bottomAnchor, constant: 12),
            tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionTextField.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setUpLeftViewForTextField(_ textField: UITextField, label: String) {
        let leftLabel = UILabel()
        leftLabel.text = label
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textColor = .gray
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        containerView.addSubview(leftLabel)
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8)
        ])
        
        textField.leftView = containerView
        textField.leftViewMode = .always
    }
    
    @objc private func sendButtonTapped() {
        guard let text = descriptionTextField.text, !text.isEmpty else {
            print("Description field is empty")
            return
        }
        print("Send button tapped with text: \(text)")
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionView DataSource and Delegate

extension AddQuestionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addingTagsCollectionView {
            return tagList.count
        } else {
            return technologiesMassive.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == addingTagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTagCellForTagsInput.identifier, for: indexPath) as? AddTagCellForTagsInput else {
                return UICollectionViewCell()
            }
            let tag = tagList[indexPath.item]
            cell.configure(with: tag) // Updated to pass the Technology object
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTagCell.identifier, for: indexPath) as? AddTagCell else {
                return UICollectionViewCell()
            }
            let technology = technologiesMassive[indexPath.item]
            cell.configure(with: technology)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == addingTagsCollectionView {
            let tag = tagList[indexPath.item]
            print("Tag \(tag.name) selected (ID: \(tag.id), Slug: \(tag.slug))")
            tagList.remove(at: indexPath.item) // Remove the selected tag
            addingTagsCollectionView.reloadData()
        } else {
            let technology = technologiesMassive[indexPath.item]
            print("Technology \(technology.name) selected (ID: \(technology.id), Slug: \(technology.slug))")
            if !tagList.contains(where: { $0.id == technology.id }) {
                tagList.append(technology)
            }
            addingTagsCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == addingTagsCollectionView {
            let tag = tagList[indexPath.item]
            let labelSize = (tag.name as NSString).size(withAttributes: [
                .font: UIFont.systemFont(ofSize: 14)
            ])
            return CGSize(width: labelSize.width + 20, height: 30)
        } else {
            let technology = technologiesMassive[indexPath.item]
            let labelSize = (technology.name as NSString).size(withAttributes: [
                .font: UIFont.systemFont(ofSize: 14)
            ])
            return CGSize(width: labelSize.width + 20, height: 30)
        }
    }
}


// MARK: - Custom UICollectionViewCell

class AddTagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#4F46E5")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagLabel)
        contentView.backgroundColor = UIColor(hex: "#EEF2FF")
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with technology: Technology) {
        tagLabel.text = technology.name
    }
}

// 2
// MARK: - Custom UICollectionViewCell

class AddTagCellForTagsInput: UICollectionViewCell {
    static let identifier = "AddTagCell"
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#4F46E5")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagLabel)
        contentView.backgroundColor = UIColor(hex: "#EEF2FF")
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with technology: Technology) {
        tagLabel.text = technology.name
    }
}
