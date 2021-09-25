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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView.transform = CGAffineTransform(rotationAngle: 4.7)
        setupAnimation()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAnimation() {
        let planeAnimation = Animation.named("arrow")
        animationView.animation = planeAnimation
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.play()
    }

}
