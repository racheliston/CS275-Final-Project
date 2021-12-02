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
    
    var user = ""
    var password = ""
    var confirmPassword = ""

    
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var origPass: UITextField!
    @IBOutlet var confPass: UITextField!
    
    var database: Firestore!
    
    var listBars = [String]()
    // holds capacity and line size
    var listLineInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        
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
            self.user = u
        } else {
            empty = true
        }
        
        if let p = origPass.text, p != "" {
            self.password = p
        } else {
            empty = true
        }
        
        if let cP = confPass.text, cP != "" {
            self.confirmPassword = cP
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
            // Add a new document in collection "managers"
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
            let docRef = database.collection("managers").document("\(self.user)")
            
            let colRef = database.collection("managers")
            
            
            listBars.append("Bar Name")
            
            database.collection("managers").getDocuments() {
                (QuerySnapshot, err) in
                if let err = err {
                    print("error!!!!!!!!")
                    return
                }

                for manager in QuerySnapshot!.documents {
                    //print("\(manager.documentID)")
                    //print("\(manager.documentID) \(manager.data())")
                    self.listBars.append(manager.documentID)
                    //print(self.barNames)
                }
            }

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // The username exists, present the alert controller
                    print("Username is already in the database")
                    self.present(alertUsernameMade, animated: true, completion: nil)

                } else {
                    // The username does not exist, create the data
                    // Check that the passwords match
                    if self.password != self.confirmPassword {
                        self.present(alertPasswordsDifferent, animated: true, completion: nil)
                    } else {
                        // Everything matches, add a new document
                        docRef.setData([
                            "password": "\(self.password)"
                        ]) { err in
                            if let err = err {
                                print("Error writing the document: \(err)")
                            } else {
                                print("Document successfully written!")
                                // The account has been created, go to the account settings page

                                let managerInfo = self.storyboard?.instantiateViewController(withIdentifier: "ManagerInformationViewController") as! ManagerInformationViewController
                            
                                managerInfo.userName = self.user
                                
                                let patronView = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
                                
                                //patronView.barNames = self.user
                                self.listBars.append(self.user)
                                
                                patronView.barNames = self.listBars
                                
                                self.tabBarController?.present(patronView, animated: true, completion: nil)
                                
                                print("\(patronView.barNames)")
                                
                                self.navigationController?.pushViewController(managerInfo, animated: true)
                            }
                        }
                    }

                }
            }
            
        }
        
    }
    
    
    
}
