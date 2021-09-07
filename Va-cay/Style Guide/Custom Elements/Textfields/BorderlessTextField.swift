//
//  BorderlessTextField.swift
//  Va-cay
//
//  Created by James Lea on 9/3/21.
//

import UIKit

class BorderlessTextField: UITextField {
    
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
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        updateFontTo(font: FontNames.systemFont)
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
