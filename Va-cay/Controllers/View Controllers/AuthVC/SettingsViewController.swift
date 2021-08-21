//
//  SettingsViewController.swift
//  Va-cay
//
//  Created by James Lea on 8/2/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var LogOutButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func LogOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {return}
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true, completion: nil)
        } catch {
            print("Error signing out: %@")
        }
    }
    
    //MARK: - Functions
    func updateViews() {
        LogOutButton.backgroundColor = .systemRed
        LogOutButton.layer.cornerRadius = 10
    }
    
}//End of class
