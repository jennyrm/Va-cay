//
//  Styleguide.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/26/21.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}//End of extension

struct Colors {
    static let customLightBlue = UIColor(named: "customLightBlue")
    static let customDarkBlue = UIColor(named: "customDarkBlue")
    static let customOffWhite = UIColor(named: "customOffWhite")
    static let customLightGray = UIColor(named: "customLightGray")
    static let customDarkGray = UIColor(named: "customDarkGray")
}//End of struct

struct FontNames {
    static let systemFont = "System"
}//End of struct
