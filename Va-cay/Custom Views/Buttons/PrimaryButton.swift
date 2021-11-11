//
//  PrimaryButton.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/28/21.
//

import UIKit

class PrimaryButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupButton() {
        addCornerRadius(30)
        
        addAccentBorder(width: 2, color: Colors.customLightGray!)
        
        updateFontTo(font: FontNames.systemFont)
        
        setTitleColor(.black, for: .normal)
        self.backgroundColor = Colors.customLightBlue
    }

    func updateFontTo(font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)
    }
    
}//End of class

