//
//  ManagerSettings.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 10/18/21.
//

import UIKit

class ManagerSettingsViewController: UIViewController {
    
    // Make a button to sign out
    @IBOutlet var signOutButton: UIButton!
    
    // Pop all view controllers off the stack if sign out is pressed
    @IBAction func signOut(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
