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
    
    func setupTextfield() {
        self.addCornerRadius()
        self.addAccentBorder()
        
        updateFontTo(font: FontNames.verdanaBold)
        
        self.backgroundColor = .white
        self.layer.masksToBounds = true
    }
    
    func setPlaceholderText() {
        let currentPlaceholder = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : Colors.customGreen, NSAttributedString.Key.font: UIFont(name: FontNames.verdanaBold, size: 16)!
        ])
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)
    }
    
}//End of class

