//
//  Styleguide.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/26/21.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat = 30) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = .darkGray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}//End of extension

struct Colors {
    static let customLightBlue = UIColor(red: 145/255, green: 189/255, blue: 202/255, alpha: 1)
    static let customOffWhite = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
    static let customLightGray = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    static let customDarkGray = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
}//End of struct


struct FontNames {
    static let systemFont = "System"
}//End of struct
