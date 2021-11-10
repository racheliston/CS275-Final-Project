//
//  ManagerCreateAccount.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 11/10/21.
//

import UIKit


class ManagerCreateAccountViewController: UIViewController {
    
    
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var origPass: UITextField!
    @IBOutlet var confPass: UITextField!
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        var user = ""
        var password = ""
        var confirmPassword = ""
        // Set a boolean that is true if any of the fields are empty
        var empty = false
        
        // Create an alert controller in case they leave a field blank
        let alertController = UIAlertController(title: nil,
                                                message: "Please fill out all text fields",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
    
        // Make sure the text fields are not empty when pressed
        if let u = userName.text {
            user = u
        } else {
            empty = true
        }
        
        if let p = origPass.text {
            password = p
        } else {
            empty = true
        }
        
        if let cP = confPass.text {
            confirmPassword = cP
        } else {
            empty = true
        }
        
        // If empty is true, display an alert controller telling them their fields cannot be empty
        if empty {
            present(alertController, animated: true, completion: nil)
        } else {
            // All the fields are filled, make sure the username is not in the database
        }
        
    }
    
    
    
}
