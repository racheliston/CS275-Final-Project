//
//  ManagerSignIn.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 10/18/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ManagerSignInViewController: UIViewController {
    
    var database: Firestore!
    @IBOutlet var userName: UITextField!
    @IBOutlet var passWord: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
    }
    
    @IBAction func checkInformation(_ sender: Any) {
        // Make sure both the fields are filled out
        var user = ""
        var password = ""
        
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
        
        if let p = passWord.text, p != "" {
            password = p
        } else {
            empty = true
        }
        
        // If empty is true, display an alert controller telling them their fields cannot be empty
        if empty {
            present(alertTextFieldsEmpty, animated: true, completion: nil)
        } else {
            // Read in the data by the username and see if the
            // passwords match
            let alertUsernameNonexistent = UIAlertController(title: nil,
                                                      message: "Username not in database",
                                                      preferredStyle: .alert)
            alertUsernameNonexistent.addAction(okAction)
            
            let alertPasswordsDifferent = UIAlertController(title: nil,
                                                            message: "Invalid password, please try again",
                                                            preferredStyle: .alert)
            
            alertPasswordsDifferent.addAction(okAction)
            let docRef = database.collection("managers").document("\(user)")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    // Username is in the database,
                    print("Document data: \(dataDescription)")
                    // Get the value of password
                    let fields = dataDescription.components(separatedBy: ",")
                    var found = ""
                    for i in fields {
                        if i.contains("password") {
                            found = i
                        }
                    }
                    
                    if found.contains(password) {
                        // The account has been created, go to the account settings page
                        let managerHome = self.storyboard?.instantiateViewController(withIdentifier: "ManagerHomeViewController") as! ManagerHomeViewController
                        self.navigationController?.pushViewController(managerHome, animated: true)
                    } else {
                        // If the password is incorrect
                        print("Password is incorrect")
                        self.present(alertPasswordsDifferent, animated: true, completion: nil)
                        
                    }
                    
                    
                } else {
                    // If the username is not found in the database let the user know
                    print("Username not in the database")
                    self.present(alertUsernameNonexistent, animated: true, completion: nil)
                }
            }
        }
    }
    
}
