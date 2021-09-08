//
//  BorderedStackView.swift
//  Va-cay
//
//  Created by James Lea on 9/3/21.
//

import UIKit

class BorderedStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupStackView() {
        addAccentBorder(width: 1, color: Colors.customDarkGray)
        addCornerRadius(6)
        
//        updateFontTo(font: FontNames.systemFont)
        
//        self.backgroundColor = .white
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 10
    }
    
}//End of class
