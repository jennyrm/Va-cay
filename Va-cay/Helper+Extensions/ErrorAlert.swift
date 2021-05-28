//
//  ErrorAlert.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/27/21.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
}//End of extension
