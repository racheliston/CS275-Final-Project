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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
    }
    
    
}
