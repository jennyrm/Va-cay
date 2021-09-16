//
//  AuthViewController.swift
//  Va-cay
//
//  Created by James Lea on 7/28/21.
//

import UIKit
import FirebaseAuth
import Lottie

class AuthViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordOneTextField: UITextField!
    @IBOutlet weak var passwordTwoTextField: UITextField!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    //MARK: - Properties
    var loginBool: Bool = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        setupOutlets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        errorLabel.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func loginRegisterButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordOneTextField.text, !password.isEmpty else {
            
            errorLabel.text = "Please fill out all fields"
            errorLabel.isHidden = false
            return
        }
        
        if loginBool {
            AuthViewModel.login(email: email, password: password) { result in
                print("result", result)
//                if result == "Succesfully created account" {
//                    self.transitionToHome()
//                } else {
//                    self.errorLabel.text = result
//                    self.errorLabel.isHidden = false
//                }
            }
        } else {
            guard let confirmPass = passwordTwoTextField.text, !confirmPass.isEmpty else {
                errorLabel.text = "Please fill out all fields"
                errorLabel.isHidden = false
                return
            }
            
            AuthViewModel.register(email: email, password: password, confirmPassword: confirmPass) { result in
                print(result)
//                if result {
//                    self.transitionToHome()
//                } else {
//                    self.errorLabel.text = "Error signing up"
//                    self.errorLabel.isHidden = false
//                }
            }
        }
    }
    
    // JAMLEA: - Switches outlets to be displayed when user is trying login or register
    @IBAction func switchButtonTapped(_ sender: Any) {
        loginBool.toggle()
        
        if loginBool {
            passwordOneTextField.text = ""
            passwordTwoTextField.text = ""
            passwordTwoTextField.isHidden = true
            
            switchButton.setTitle("Register here", for: .normal)
            loginRegisterButton.setTitle("Login", for: .normal)
            
            errorLabel.isHidden = true
        } else {
            passwordOneTextField.text = ""
            passwordTwoTextField.text = ""
            passwordTwoTextField.isHidden = false
            
            switchButton.setTitle("Sign in here", for: .normal)
            loginRegisterButton.setTitle("Register", for: .normal)
            
            errorLabel.isHidden = true
        }
    }
    
    // MARK: - Functions
    func transitionToHome(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupAnimation(){
//        let planeAnimation = Animation.named("plane5")
//        animationView.animation = planeAnimation
//        animationView.loopMode = .loop
//        animationView.play()
    }
    
    func setupOutlets() {
//        animationView.backgroundColor = nil
//        
//        passwordOneTextField.isSecureTextEntry = true
//        passwordTwoTextField.isSecureTextEntry = true
//        passwordTwoTextField.isHidden = true
//        
//        errorLabel.isHidden = true
//        
//        switchButton.setTitle("Register here", for: .normal)
    }
    
}//End of class
