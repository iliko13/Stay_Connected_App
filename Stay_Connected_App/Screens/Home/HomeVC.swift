//
//  HomeViewController.swift
//  Stay_Connected
//
//  Created by iliko on 11/29/24.
//

import UIKit
import Foundation

// MARK: - Main Question Model
struct Question {
    let id: Int
    let title: String
    let question: String
    let publisher: String
    let publishedAt: PublishedAt
    let replies: [Reply]
    let tags: [String]
    let isAnswered: Bool
}

// MARK: - PublishedAt Model
struct PublishedAt {
    let date: String
    let hour: String
}

// MARK: - Reply Model
struct Reply {
    let commentId: Int
    let commentText: String
    let commenterName: String
    let commenterProfilePicture: String
    let commentDate: String
    let isAccepted: Bool
}

// MARK: - Mock Data
let mockData: [Question] = [
    Question(
        id: 1,
        title: "How to use UICollectionView in Swift?",
        question: "I need help implementing a UICollectionView in my project. Can someone help?",
        publisher: "John Doe",
        publishedAt: PublishedAt(date: "11/24/2024", hour: "00:33"),
        replies: [
            Reply(
                commentId: 101,
                commentText: "You can use a UICollectionViewFlowLayout.",
                commenterName: "Jane Smith",
                commenterProfilePicture: "profile_pic_url",
                commentDate: "Monday, 9 May 2024",
                isAccepted: false
            ),
            Reply(
                commentId: 102,
                commentText: "Check Apple's documentation for UICollectionView.",
                commenterName: "Michael Brown",
                commenterProfilePicture: "profile_pic_url",
                commentDate: "Tuesday, 10 May 2024",
                isAccepted: true
            )
        ],
        tags: ["iOS", "Swift", "UICollectionView"],
        isAnswered: true
    ),
    Question(
        id: 2,
        title: "What is the difference between UIView and CALayer?",
        question: "Can someone explain the difference between UIView and CALayer in UIKit?",
        publisher: "Alice Johnson",
        publishedAt: PublishedAt(date: "11/24/2024", hour: "01:15"),
        replies: [],
        tags: ["iOS", "UIKit", "UIView", "CALayer"],
        isAnswered: false
    )
]


class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Questions", color: .black, isBold: true, size: 20)
        return label
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
    
    private let tags = ["iOS", "Frontend", "Backend", "SwiftUI", "UIKit", "Python"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        SetupUI()
        configureActions()
    }
    
    private func SetupUI() {
        addingViews()
        setupConstraints()
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
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            generalButton.widthAnchor.constraint(equalToConstant: 180),
            generalButton.heightAnchor.constraint(equalToConstant: 39),
            generalButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            generalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            privateButton.widthAnchor.constraint(equalToConstant: 180),
            privateButton.heightAnchor.constraint(equalToConstant: 39),
            privateButton.topAnchor.constraint(equalTo: generalButton.topAnchor),
            privateButton.leadingAnchor.constraint(equalTo: generalButton.trailingAnchor, constant: 9),
            
            searchBar.widthAnchor.constraint(equalToConstant: 362),
            searchBar.heightAnchor.constraint(equalToConstant: 38),
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
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else {
            fatalError("Could not dequeue TagCell")
        }
        cell.configure(with: tags[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionView DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tags[indexPath.item]
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 20
        return CGSize(width: width, height: 30)
    }
    
    // >>>>>>>>>>>>>>>>>>>>> TagCell
    
    
    
    
    
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? CustomTableViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        cell.backgroundColor = .white
        let question = mockData[indexPath.row]
        cell.configureTableCell(
            title: question.title,
            subtitle: question.publisher,
            repliesCount: question.replies.count,
            isAnswered: question.isAnswered
        )

        
        return cell
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






