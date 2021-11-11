//
//  ManagerCreateAccount.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 11/10/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class ManagerCreateAccountViewController: UIViewController {
    
    
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var origPass: UITextField!
    @IBOutlet var confPass: UITextField!
    
    var database: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        var user = ""
        var password = ""
        var confirmPassword = ""
        // Set a boolean that is true if any of the fields are empty
        var empty = false
        
        // Create an alert controller in case they leave a field blank
        let alertTextFieldsEmpty = UIAlertController(title: nil,
                                                message: "Please fill out all text fields",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertTextFieldsEmpty.addAction(okAction)
    
        // Make sure the text fields are not empty when pressed
        if let u = userName.text, u != "" {
            user = u
        } else {
            empty = true
        }
        
        if let p = origPass.text, p != "" {
            password = p
        } else {
            empty = true
        }
        
        if let cP = confPass.text, cP != "" {
            confirmPassword = cP
        } else {
            empty = true
        }
        
        // If empty is true, display an alert controller telling them their fields cannot be empty
        if empty {
            present(alertTextFieldsEmpty, animated: true, completion: nil)
        } else {
            let alertUsernameMade = UIAlertController(title: nil,
                                                      message: "Please choose a different username",
                                                      preferredStyle: .alert)
            alertUsernameMade.addAction(okAction)
            
            let alertPasswordsDifferent = UIAlertController(title: nil,
                                                            message: "Please make sure passwords match",
                                                            preferredStyle: .alert)
            
            alertPasswordsDifferent.addAction(okAction)
            // Add a new document in collection "cities"
//            database.collection("managers").document("\(user)").setData([
//                "password": "\(password)"
//            ]) { err in
//                if let err = err {
//                    print("Error writing document: \(err)")
//                } else {
//                    print("Document successfully written!")
//                }
//            }
            // All the fields are filled, make sure the username is not in the database
            let docRef = database.collection("managers").document("\(user)")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // The username exists, present the alert controller
                    print("Username is already in the database")
                    self.present(alertUsernameMade, animated: true, completion: nil)

                } else {
                    // The username does not exist, create the data
                    // Check that the passwords match
                    if password != confirmPassword {
                        self.present(alertPasswordsDifferent, animated: true, completion: nil)
                    } else {
                        // Everything matches, add a new document
                        docRef.setData([
                            "password": "\(password)"
                        ]) { err in
                            if let err = err {
                                print("Error writing the document: \(err)")
                            } else {
                                print("Document successfully written!")
                                // The account has been created, go to the account settings page
                                let managerInfo = self.storyboard?.instantiateViewController(withIdentifier: "ManagerInformationViewController") as! ManagerInformationViewController
                                self.navigationController?.pushViewController(managerInfo, animated: true)
                            }
                        }
                    }

                }
            }
            
        }
        
    }
    
    
    
}
