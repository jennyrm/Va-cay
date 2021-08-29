//
//  PrimaryButton.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/26/21.
//

import UIKit

class SecondaryButton: UIButton {
    
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
        updateFontTo(font: FontNames.systemFont)
        
        setTitleColor(.white, for: .normal)
        self.backgroundColor = Colors.customBlue
        self.addCornerRadius()
    }

    func updateFontTo(font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)
    }
    
}//End of class
