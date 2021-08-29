//
//  PrimaryLabel.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/28/21.
//

import UIKit

class PrimaryLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupLabel() {
        self.textColor = .black
        self.backgroundColor = .systemGray6
        updateFontTo(font: FontNames.verdanaBold)
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)
    }
    
}//End of class
