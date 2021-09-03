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
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = .lightGray) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}//End of extension

struct Colors {
    static let customGreen = UIColor(red: 0/255, green: 187/255, blue: 135/255, alpha: 1)
    static let customLightGreen = UIColor(red: 190/255, green: 255/255, blue: 172/255, alpha: 1)
    static let customDarkGreen = UIColor(red: 1/255, green: 92/255, blue: 66/255, alpha: 1)
    static let customYellow = UIColor(red: 238/255, green: 200/255, blue: 87/255, alpha: 1)
    static let customLightGray = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
}//End of struct

struct FontNames {
    static let systemFont = "System"
}//End of struct
