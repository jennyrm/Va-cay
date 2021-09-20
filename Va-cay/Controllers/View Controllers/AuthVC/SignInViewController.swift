//
//  LoginViewController.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit
import FirebaseAuth
import FirebaseOAuthUI
import GoogleSignIn

class SignInViewController: UIViewController {
    
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
            if result == "User logged in" {
                self.transitionToHome()
            } else {
                self.presentErrorAlert(title: "Error", message: result)
            }
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        forgotPassword()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: GoogleClientID.clientID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            guard let email = user.profile?.email else { return }
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
        signInLabel.layer.cornerRadius = 14
        passwordTextfield.isSecureTextEntry = true
    }

}//End of class

extension SignInViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("Nice! You've signed in as \(user.uid). Your email is: \(user.email ?? "")")
            
            let userDoc = User(email: user.email!, userId: user.uid)
            UserController.sharedInstance.createUser(user: userDoc)
            
            self.transitionToHome()
        }
    }
}//End of extension
