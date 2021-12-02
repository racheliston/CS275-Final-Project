//
//  ManagerSettings.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 10/18/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ManagerSettingsViewController: UIViewController {
    
    // Create a username variable
    var userName = ""
    var database : Firestore!
    
    // Make a button to change total capacity
    @IBOutlet var totalCapButton: UIButton!
    
    
    // Make a button to change hours
    
    
    // Make a button to change address
    
    // Make a button to sign out
    @IBOutlet var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("In manager setttings: " + "\(userName)")
        
        database = Firestore.firestore()
    }
    
    
    @IBAction func changeCap(_ sender: Any) {
        
        let cont = UIAlertController(title: "Enter new capacity", message: nil, preferredStyle: .alert)
        
        cont.addTextField()
        
        // If the user presses submit, send new capacity to database
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned cont] _ in
            // Get the data
            var cap = 100
            let capacity = cont.textFields![0].text
            if let c = cont.textFields![0].text, c != "" {
                cap = Int(c)!
            }
            
            
            print("\(cap)")
            
            // Query the database
            let docRef = self.database.collection("managers").document("\(self.userName)")
            
            docRef.updateData([
                "capacity": "\(cap)"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
        
        cont.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cont.addAction(cancelAction)
        
        present(cont, animated: true, completion: nil)
    }
    
    
    
    // Pop all view controllers off the stack if sign out is pressed
    @IBAction func signOut(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeVC = segue.destination as? ManagerHomeViewController else { return }
        homeVC.viewDidLoad()
    }

}
