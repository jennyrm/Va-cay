//
//  LoginViewController.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInLabel: PrimaryButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Actions
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty else {return}
        
        AuthViewModel.login(email: email, password: password) { result in
            if result {
                self.transitionToHome()
            } else {
                let errorController = UIAlertController(title: "Error", message: "Error logging in", preferredStyle: .alert)
                errorController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        forgotPassword()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func transitionToHome(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func forgotPassword() {
        let forgotPasswordAlert = UIAlertController(title: "Please Enter Email Address", message: "You will be sent an email to change your Password", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { textField in
            textField.placeholder = "Email"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Send Email", style: .default, handler: { _ in
            guard let resetEmail = forgotPasswordAlert.textFields?.first?.text else {return}
            Auth.auth().sendPasswordReset(withEmail: resetEmail) { error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    print("Could not send email for password reset")
                } else {
                    print("Email Sent")
                }
            }
        }))
        present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    func updateView() {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        signInLabel.layer.cornerRadius = 14
    }

}//End of class

