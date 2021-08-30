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
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = Colors.customBlue) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}//End of extension

struct Colors {
    static let customBlue = UIColor(red: 121/255, green: 214/255, blue: 249/255, alpha: 1)
    static let customGreen = UIColor(red: 211, green: 243, blue: 142, alpha: 1)
    static let customYellow = UIColor(red: 243, green: 242, blue: 160, alpha: 1)
}//End of struct

struct FontNames {
    static let systemFont = "System-Semibold"
}//End of struct
