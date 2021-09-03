//
//  MapPinButton.swift
//  Va-cay
//
//  Created by James Lea on 8/30/21.
//

import UIKit

class MapPinButton: UIButton {
    
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
        self.setImage(UIImage(named: "pin"), for: .normal)
    }
    
}//End of class
