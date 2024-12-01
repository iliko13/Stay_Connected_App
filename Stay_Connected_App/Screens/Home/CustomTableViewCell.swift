//
//  CustomTableViewCell.swift
//  Stay_Connected
//
//  Created by iliko on 12/1/24.
//

import UIKit

// MARK: - Custom UITableViewCell
class CustomTableViewCell: UITableViewCell {
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Email", color: .black, isBold: false, size: 18)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "Simple Text", color: .black, isBold: false, size: 20)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private var repliesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureCustomText(text: "replies: 5", color: .black, isBold: false, size: 13)
        label.textColor = UIColor(hex: "5E6366")
        return label
    }()
    
    private var tickContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = .green
        return view
    }()
    
    private var tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        return imageView
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(customLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(repliesLabel)
        contentView.addSubview(tickContainerView)
        tickContainerView.addSubview(tickImageView)
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: customLabel.leadingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: customLabel.topAnchor, constant: 2),
            
            repliesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            repliesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            
            tickContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            tickContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 65),
            tickContainerView.widthAnchor.constraint(equalToConstant: 30),
            tickContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            tickImageView.centerXAnchor.constraint(equalTo: tickContainerView.centerXAnchor),
            tickImageView.centerYAnchor.constraint(equalTo: tickContainerView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableCell(title: String, subtitle: String, repliesCount: Int, isAnswered: Bool) {
        customLabel.text = title
        subTitleLabel.text = subtitle
        repliesLabel.text = "Replies: \(repliesCount)"
        tickContainerView.isHidden = !isAnswered
    }
}
