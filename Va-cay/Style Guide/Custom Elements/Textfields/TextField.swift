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
        self.addAccentBorder()
        
        updateFontTo(font: FontNames.systemFont)
        
        self.backgroundColor = .white
        self.borderStyle = .line
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    func setPlaceholderText() {
        let currentPlaceholder = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : Colors.customGreen, NSAttributedString.Key.font: UIFont(name: FontNames.systemFont, size: 16)!
        ])
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)
    }
    
}//End of class

