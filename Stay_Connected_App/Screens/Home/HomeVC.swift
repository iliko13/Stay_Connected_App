//
//  HomeViewController.swift
//  Stay_Connected
//
//  Created by iliko on 11/29/24.
//

import UIKit
import NetworkPackage

struct Author: Codable {
    let id: Int
    let fullname: String
    let email: String
    let rating: Int
}

struct Technology: Codable {
    let id: Int
    let name: String
    let slug: String
}

var technologiesMassive: [Technology] = []
var questionsMassive: [Question] = []

final class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var selectedIndexPath: IndexPath?
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Questions", color: .black, isBold: true, size: 20)
        return label
    }()
    
    private let addQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(hex: "#4F46E5")
        button.addTarget(self, action: #selector(addQuestionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let generalButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureWith(title: "General", fontSize: 16, titleColor: .white, backgroundColor: UIColor(hex: "#4E53A2"))
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let privateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configureWith(title: "Private", fontSize: 16, titleColor: .white, backgroundColor: UIColor(hex: "#777E99"))
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "TableCell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let networkService: NetworkService = NetworkPackage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        SetupUI()
        configureActions()
        self.tabBarController?.tabBar.isHidden = false
        
        searchBar.delegate = self
        
        test()
        test2()
    }
    
    var selectedTag: String? = nil
    var searchQuery: String? = nil
    
    private func fetchFilteredQuestions() {
        var urlString = "http://127.0.0.1:8000/questions"
        
        if let tag = selectedTag {
            urlString += "?tags=\(tag)"
        }
        
        if let query = searchQuery {
            if urlString.contains("?") {
                urlString += "&search=\(query)"
            } else {
                urlString += "?search=\(query)"
            }
        }
        
        networkService.fetchData(from: urlString, modelType: [Question].self) { [weak self] result in
            switch result {
            case .success(let questions):
                DispatchQueue.main.async {
                    questionsMassive = questions
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch filtered questions: \(error)")
            }
        }
    }

    
    // testing tags
    
    private func test() {
        networkService.fetchData(from: "http://127.0.0.1:8000/tags/", modelType: [Technology].self) { [weak self] result in
            switch result {
            case .success(let technologies):
                DispatchQueue.main.async {
                    technologiesMassive = technologies
                    self?.tagsCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch technologies: \(error)")
            }
        }
    }
    
    // ......................
    
    private func test2() {
        networkService.fetchData(from: "http://127.0.0.1:8000/questions", modelType: [Question].self) { [weak self] result in
            switch result {
            case .success(let technologies):
                DispatchQueue.main.async {
                    questionsMassive = technologies
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch Questions >>>>>>>>: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        test2()
    }
    
    private func SetupUI() {
        addingViews()
        setupConstraints()
    }
    
    @objc private func addQuestionButtonTapped() {
        let addQuestionVC = AddQuestionViewController()
        addQuestionVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addQuestionVC)
        navigationController.modalPresentationStyle = .automatic
        present(navigationController, animated: true, completion: nil)
    }

    
    
    private func configureActions() {
        generalButton.addTarget(self, action: #selector(generalButtonTapped), for: .touchUpInside)
        privateButton.addTarget(self, action: #selector(privateButtonTapped), for: .touchUpInside)
    }
    
    @objc private func generalButtonTapped() {
        updateButtonStates(activeButton: generalButton, inactiveButton: privateButton)
    }
    
    @objc private func privateButtonTapped() {
        updateButtonStates(activeButton: privateButton, inactiveButton: generalButton)
    }
    
    private func updateButtonStates(activeButton: UIButton, inactiveButton: UIButton) {
        activeButton.backgroundColor = UIColor(hex: "#4E53A2")
        inactiveButton.backgroundColor = UIColor(hex: "#777E99")
    }
    
    private func addingViews() {
        view.addSubview(questionLabel)
        view.addSubview(generalButton)
        view.addSubview(privateButton)
        view.addSubview(searchBar)
        view.addSubview(tagsCollectionView)
        view.addSubview(tableView)
        view.addSubview(addQuestionButton)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            addQuestionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 115),
            addQuestionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addQuestionButton.widthAnchor.constraint(equalToConstant: 60),
            addQuestionButton.heightAnchor.constraint(equalToConstant: 60),
            
            generalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            generalButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            generalButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            generalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            privateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            privateButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            privateButton.topAnchor.constraint(equalTo: generalButton.topAnchor),
            privateButton.leadingAnchor.constraint(equalTo: generalButton.trailingAnchor, constant: 9),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: generalButton.bottomAnchor, constant: 19),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 30),
            tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 13),
            
            tableView.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
        ])
    }
    
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return technologiesMassive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else {
            fatalError("Could not dequeue TagCell")
        }
        let technology = technologiesMassive[indexPath.item]
        cell.configure(with: technology)
        if indexPath == selectedIndexPath {
            cell.layer.shadowColor = UIColor(hex: "#4F46E5").cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 6
            cell.layer.shadowOpacity = 0.8
            cell.layer.masksToBounds = false
        } else {
            cell.layer.shadowOpacity = 0
        }
        return cell
    }

    // MARK: - UICollectionView DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let technology = technologiesMassive[indexPath.item]
        let width = technology.name.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 20
        return CGSize(width: width, height: 30)
    }
    
    // >>>>>>>>>>>>>>>>>>>>> TagCell
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTechnology = technologiesMassive[indexPath.item]
        if selectedTag == selectedTechnology.slug {
            selectedTag = nil
            selectedIndexPath = nil
        } else {
            selectedTag = selectedTechnology.slug
            selectedIndexPath = indexPath
        }
        
        collectionView.reloadData()
        fetchFilteredQuestions()
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText.isEmpty ? nil : searchText
        fetchFilteredQuestions()
    }
    
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsMassive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? CustomTableViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        cell.backgroundColor = .white
        let question = questionsMassive[indexPath.row]
        cell.configureTableCell(
            title: question.title,
            description: question.description,
            answersCount: question.answersCount,
            tagNames: question.tagNames,
            author: question.author,
            createdAt: question.createdAt,
            hasCorrectAnswer: question.hasCorrectAnswer
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedQuestion = questionsMassive[indexPath.row]
        print("Selected question: \(selectedQuestion.title)")
        
        let questionDetails = QuestionDetailsViewController()
        questionDetails.question = selectedQuestion
        
        navigationController?.pushViewController(questionDetails, animated: true)
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    // >>>>>>>>>>>>>>> CustomTableViewCell
}

extension HomeVC: AddQuestionDelegate {
    func didAddQuestion() {
        test2()
    }
}








