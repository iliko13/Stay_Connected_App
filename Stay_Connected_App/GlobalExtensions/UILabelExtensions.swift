
import UIKit

extension UILabel {
    func configureCustomText(text: String, color: UIColor, isBold: Bool, size: CGFloat, alignment: NSTextAlignment = .left, lineNumber: Int = 0) {
        self.text = text
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = lineNumber
        
        if isBold {
            self.font = UIFont.boldSystemFont(ofSize: size)
        } else {
            self.font = UIFont.systemFont(ofSize: size)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

import UIKit

extension UILabel {
    
    func createAttributedText(text: String, firstWordColor: UIColor, restColor: UIColor, firstWordFont: UIFont, restFont: UIFont) {
        let words = text.components(separatedBy: " ")
        
        guard let firstWord = words.first else { return }
        
        let attributedString = NSMutableAttributedString()
        
        let firstWordAttr: [NSAttributedString.Key: Any] = [
            .foregroundColor: firstWordColor,
            .font: firstWordFont
        ]
        attributedString.append(NSAttributedString(string: firstWord, attributes: firstWordAttr))
        
        if words.count > 1 {
            let restOfText = " " + words.dropFirst().joined(separator: " ")
            let restAttr: [NSAttributedString.Key: Any] = [
                .foregroundColor: restColor,
                .font: restFont
            ]
            attributedString.append(NSAttributedString(string: restOfText, attributes: restAttr))
        }
        
        self.attributedText = attributedString
    }
}
