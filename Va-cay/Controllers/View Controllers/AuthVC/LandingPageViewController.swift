//
//  LandingPageViewController.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit
import AVKit
import AVFoundation
import AuthenticationServices

class LandingPageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var videoView: QueuePlayerUIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createAccountLabel: PrimaryButton!
    @IBOutlet weak var signInLabel: PrimaryButton!
    
    // MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Functions
    func updateView() {
//        titleLabel.backgroundColor = Colors.tableVCBackgroundColor
//        titleLabel.layer.cornerRadius = 12
//        titleLabel.layer.masksToBounds = true
    }
    
}//End of class

