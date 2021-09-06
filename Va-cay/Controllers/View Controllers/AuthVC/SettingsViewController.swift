//
//  SettingsViewController.swift
//  Va-cay
//
//  Created by James Lea on 8/2/21.
//

import UIKit
import FirebaseAuth
import Lottie

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        self.view.backgroundColor = #colorLiteral(red: 0.4660670161, green: 0.7799585462, blue: 0.8957038522, alpha: 1)
        setupAnimation()
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
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        presentAlertToChangePassword()
    }
    
    //MARK: - Functions
    func updateViews() {
        guard let user = UserController.shared.user else {return}
        emailLabel.text = user.email
        changePasswordButton.layer.cornerRadius = 10
        logOutButton.backgroundColor = .systemRed
        logOutButton.layer.cornerRadius = 10
    }
    
    func setupAnimation(){
        let planeAnimation = Animation.named("plane1")
        animationView.animation = planeAnimation
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.4
        animationView.play()
    }
    
    func presentAlertToChangePassword() {
        let alert = UIAlertController(title: "Are you sure you want to change your password?", message: "If so, please type in your current password to change", preferredStyle: .alert)
        
        alert.addTextField { newPasswordTextField in
            newPasswordTextField.placeholder = "New Password"
        }
        
        alert.addTextField { confirmNewPassword in
            confirmNewPassword.placeholder = "Confirm New Password"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            guard let newPassword = alert.textFields?.first?.text, !newPassword.isEmpty,
                  let confirmNewPassword = alert.textFields?.last?.text, !confirmNewPassword.isEmpty
            else {return}
            if newPassword == confirmNewPassword {
                UserController.shared.updatePassword(password: newPassword)
            } else {
                print("Passwords do not match")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}//End of class
