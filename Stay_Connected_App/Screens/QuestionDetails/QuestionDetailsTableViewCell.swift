//
//  QuestionDetailsTableViewCell.swift
//  Stay_Connected
//
//  Created by Sandro Maraneli on 01.12.24.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let acceptedLabel = UILabel()
    let commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "questionCell")
        
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "userPhoto")
        self.contentView.addSubview(profileImageView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(nameLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)
        
        acceptedLabel.font = UIFont.systemFont(ofSize: 13)
        acceptedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(acceptedLabel)
        
        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont.systemFont(ofSize: 15)
        commentLabel.textColor = .darkGray
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(commentLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            acceptedLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            acceptedLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30),
            
            commentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            commentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
