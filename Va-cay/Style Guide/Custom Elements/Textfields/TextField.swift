//
//  Textfields.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/26/21.
//

import UIKit

class TextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextfield()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextfield()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupTextfield() {
        self.addAccentBorder(width: 1, color: Colors.customDarkGray)
        
        updateFontTo(font: FontNames.systemFont)
        
        self.backgroundColor = .systemGray6
        self.layer.masksToBounds = true
        self.borderStyle = .line
        self.layer.cornerRadius = 6
    }
    
    func setPlaceholderText() {
        let currentPlaceholder = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : Colors.customLightBlue, NSAttributedString.Key.font: UIFont(name: FontNames.systemFont, size: 16)!
        ])
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)
    }
    
}//End of class

