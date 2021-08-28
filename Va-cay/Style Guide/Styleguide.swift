//
//  Styleguide.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/26/21.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = Colors.customGreen) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}//End of extension

struct Colors {
    static let customGreen = UIColor(red: 50/255, green: 216/255, blue: 127/255, alpha: 1)
}//End of struct

struct FontNames {
    static let verdanaBold = "Verdana-Bold"
}//End of struct
