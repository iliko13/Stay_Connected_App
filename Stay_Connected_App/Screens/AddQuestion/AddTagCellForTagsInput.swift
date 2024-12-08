
import UIKit

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
