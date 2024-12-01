//
//  CustomTableViewCell.swift
//  Stay_Connected
//
//  Created by iliko on 12/1/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Sample tags
    private let tags = ["iOS", "Frontend", "Backend", "SwiftUI", "UIKit", "Python"]
    
    // MARK: - UI Elements
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.textColor = UIColor(hex: "5E6366")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Simple Text"
        label.textColor = UIColor(hex: "5E6366")
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var repliesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Replies: 5"
        label.textColor = UIColor(hex: "5E6366")
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private var tickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(hex: "#ECFDF5")
        return view
    }()
    
    private var tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = UIColor(hex: "#059669")
        return imageView
    }()
    
    // MARK: - Collection View for Tags
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TagCellSecond.self, forCellWithReuseIdentifier: "TagCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(customLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(repliesLabel)
        contentView.addSubview(tickContainerView)
        contentView.addSubview(tagsCollectionView) 
        tickContainerView.addSubview(tickImageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: customLabel.leadingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: customLabel.topAnchor, constant: 2),
            
            repliesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            repliesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            
            tickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            tickContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 65),
            tickContainerView.widthAnchor.constraint(equalToConstant: 30),
            tickContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            tickImageView.centerXAnchor.constraint(equalTo: tickContainerView.centerXAnchor),
            tickImageView.centerYAnchor.constraint(equalTo: tickContainerView.centerYAnchor),
            
            tagsCollectionView.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 8),
            tagsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Configure Table Cell
    func configureTableCell(title: String, subtitle: String, repliesCount: Int, isAnswered: Bool) {
        customLabel.text = title
        subTitleLabel.text = subtitle
        repliesLabel.text = "Replies: \(repliesCount)"
        tickContainerView.isHidden = !isAnswered
        tagsCollectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCellSecond
        cell.configureTagCell(tag: tags[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.item]
        let width = tag.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 32
        return CGSize(width: width, height: 30)
    }

}


//

class TagCellSecond: UICollectionViewCell {
    
    private var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#4F46E5")
        label.textAlignment = .center
        label.backgroundColor = UIColor(hex: "#EEF2FF")
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagLabel)
        
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            tagLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTagCell(tag: String) {
        tagLabel.text = tag
    }
}

