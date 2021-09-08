//
//  LandingPageViewController.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit
import AVKit
import AVFoundation

class LandingPageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var videoView: QueuePlayerUIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Actions
    
    
    // MARK: - FNs
    func updateView() {
        titleLabel.backgroundColor = UIColor(white: 1, alpha: 0.8)
        titleLabel.layer.cornerRadius = 10
        titleLabel.layer.masksToBounds = true
    }
    
    // MARK: - Navigation
    
    
}//End of class
