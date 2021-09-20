//
//  HeaderLabel.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/30/21.
//

import UIKit

class HeaderLabel: UILabel {
    
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
        updateFontTo(font: FontNames.systemFont)
        self.text = "Travel Itinerary"
        
        self.font = UIFont(name: "Apple", size: 28)
//            .systemFont(ofSize: 28, weight: .semibold)
        self.layer.zPosition = 1000
        self.textAlignment = .center
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)
    }
    
}//End of class
