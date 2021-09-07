//
//  AccentView.swift
//  Va-cay
//
//  Created by Jenny Morales on 8/30/21.
//

import UIKit

class AccentView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAccentView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAccentView()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    func setupAccentView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [Colors.customOffWhite.cgColor, Colors.customLightBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        self.layer.addSublayer(gradientLayer)
    }
    
}//End of class
