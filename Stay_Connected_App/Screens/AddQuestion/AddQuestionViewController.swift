
import UIKit
import NetworkPackage


protocol AddQuestionDelegate: AnyObject {
    func didAddQuestion()
}

class AddQuestionViewController: UIViewController, UITextFieldDelegate {
    
    
    weak var delegate: AddQuestionDelegate?
    
    private var viewModel = AddQuestionViewModel()


    private let subjectField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Subject"
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
    
    private let networkService = NetworkPackage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        navigationItem.title = "Add Question"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = cancelButton
        
        descriptionTextField.delegate = self
        
        setUpLeftViewForTextField(tagField, label: "Tag:")
        
        descriptionTextField.rightView = sendButton
        descriptionTextField.rightViewMode = .always
        
        viewModel.onTagsUpdated = { [weak self] in
            self?.addingTagsCollectionView.reloadData()
        }
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
           guard let subject = subjectField.text, !subject.isEmpty else {
               print("Subject field is empty")
               return
           }
           
           guard let description = descriptionTextField.text, !description.isEmpty else {
               print("Description field is empty")
               return
           }
           
           viewModel.postQuestion(subject: subject, description: description) { [weak self] success in
               DispatchQueue.main.async {
                   if success {
                       self?.delegate?.didAddQuestion()
                       self?.dismiss(animated: true)
                       self?.showAlert(message: "Question Added Successfully!")
                   } else {
                       self?.showAlert(message: "Error")
                   }
               }
           }
       }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionView DataSource and Delegate

extension AddQuestionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addingTagsCollectionView {
            return viewModel.tagList.count
        } else {
            return technologiesMassive.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == addingTagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTagCellForTagsInput.identifier, for: indexPath) as? AddTagCellForTagsInput else {
                return UICollectionViewCell()
            }
            let tag = viewModel.tagList[indexPath.item]
            cell.configure(with: tag)
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
            viewModel.removeTag(at: indexPath.item)
        } else {
            let technology = technologiesMassive[indexPath.item]
            viewModel.addTag(technology)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == addingTagsCollectionView {
            let tag = viewModel.tagList[indexPath.item]
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

