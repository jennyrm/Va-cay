//
//  AuthViewController.swift
//  Va-cay
//
//  Created by James Lea on 7/28/21.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordOneTextField: UITextField!
    @IBOutlet weak var passwordTwoTextField: UITextField!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTwoTextField.isHidden = true
        switchButton.setTitle("Register here", for: .normal)
    }
    
    var loginBool: Bool = true
    
    // MARK: - Actions
    @IBAction func loginRegisterButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordOneTextField.text, !password.isEmpty else {return}
        if loginBool {
            AuthViewModel.login(email: email, password: password) { result in
                if result {
                    self.transitionToHome()
                }
            }
        } else {
            guard let confirmPass = passwordTwoTextField.text, !confirmPass.isEmpty else {return}
            AuthViewModel.register(email: email, password: password, confirmPassword: confirmPass) { result in
                if result {
                    self.transitionToHome()
                }
            }
        }
    }
    
    @IBAction func switchButtonTapped(_ sender: Any) {
        loginBool.toggle()
        if loginBool {
            passwordTwoTextField.isHidden = true
            switchButton.setTitle("Register here", for: .normal)
            loginRegisterButton.setTitle("Login", for: .normal)
        } else {
            passwordTwoTextField.isHidden = false
            switchButton.setTitle("Sign in here", for: .normal)
            loginRegisterButton.setTitle("Register", for: .normal)
        }
    }
    
    // MARK: - FNs
    func transitionToHome(){
        self.dismiss(animated: true, completion: nil)
    }
    
}//End of class
