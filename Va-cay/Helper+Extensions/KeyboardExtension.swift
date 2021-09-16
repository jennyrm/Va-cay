//
//  KeyboardExtension.swift
//  Va-cay
//
//  Created by Jenny Morales on 9/16/21.
//

import UIKit

extension UIViewController {
    func hideKeyBoardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}//End of extension
