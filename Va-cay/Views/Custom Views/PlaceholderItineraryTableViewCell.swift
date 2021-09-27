//
//  EmptyItinerariesTableViewCell.swift
//  Va-cay
//
//  Created by James Lea on 9/24/21.
//

import UIKit
import Lottie

class PlaceholderItineraryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var animationView: AnimationView!
    
    //MARK: - Properties
    var indexPath: Int? {
        didSet {
            setupAnimation()
        }
    }
    
    //MARK: - Functions
    func setupAnimation() {
        let planeAnimation = Animation.named("arrow")
        animationView.animation = planeAnimation
        animationView.transform = CGAffineTransform(rotationAngle: 4.7)
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.play()
    }

}//End of class
