//
//  CalendarButton.swift
//  Va-cay
//
//  Created by James Lea on 9/2/21.
//

import UIKit

class CalendarButton: UIButton {
    
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
        self.setImage(UIImage(named: "calendar"), for: .normal)
    }
    
}//End of class
