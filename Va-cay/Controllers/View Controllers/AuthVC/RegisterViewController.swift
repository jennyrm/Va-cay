//
//  RegisterViewController.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var createAccountLabel: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextfield.text, !confirmPassword.isEmpty else {return}
        AuthViewModel.register(email: email, password: password, confirmPassword: confirmPassword) { result in
            if result {
                self.transitionToHome()
            } else {
                let registerError = UIAlertController(title: "Error", message: "Login credentials are invalid", preferredStyle: .alert)
                registerError.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(registerError, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func appleRegisterButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func googleRegisterButtonTapped(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: GoogleClientID.clientID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            guard let email = user.profile?.email else {return}
            guard let idToken = user.authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                if result != nil {
                    let newUser = User(email: email, userId: result!.user.uid)
                    UserController.sharedInstance.createUser(user: newUser)
                    
                    self.transitionToHome()
                }
            }
        }
    }
    
    
    // MARK: - Functions
    func transitionToHome() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func updateView() {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        createAccountLabel.layer.cornerRadius = 14
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextfield.isSecureTextEntry = true
    }
    
}//End of class
