//
//  RegisterViewController.swift
//  Va-cay
//
//  Created by James Lea on 9/7/21.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextfield.text, !confirmPassword.isEmpty else {return}
        AuthViewModel.register(email: email, password: password, confirmPassword: confirmPassword) { result in
            if result {
                
            } else {
                
            }
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
