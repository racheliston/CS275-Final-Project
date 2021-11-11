//
//  ManagerInformation.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 11/10/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ManagerInformationViewController: UIViewController {
    
    var database: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
    }
    
    // Set the information for the user including: total capacity, hours, and address
    
}
