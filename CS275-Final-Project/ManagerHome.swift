//
//  ManagerHome.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 10/18/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ManagerHomeViewController: UIViewController {
    
    // Labels for home
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var lineLabel: UILabel!
    
    // Buttons for home
    @IBOutlet var capacityMinusButton: UIButton!
    @IBOutlet var capacityPlusButton: UIButton!
    @IBOutlet var lineMinusButton: UIButton!
    @IBOutlet var linePlusButton: UIButton!
    
    var totalCapacityValue: Int = 0
    var capacityValue: Int = 0
    var lineValue: Int = 0
    
    var userName = ""
    
    var database : Firestore!
    
    
    // For start view for capacity and label
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        database = Firestore.firestore()
        
        // Call the database to get the information
        let docRef = database.collection("managers").document("\(userName)")

        var cap = 0
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let fields = dataDescription.split(separator: ",")
                
                print("\(fields)")
                var found = String()
                for i in fields {
                    if i.contains("capacity") {
                        found = String(i)
                    }
                }
                var capVal = found.split(separator: " ")
                capVal.dropLast()
                print("\(capVal[1])")
                cap = Int(capVal[1]) ?? 100
                
                // Get the value of the capacity for the manager
                self.totalCapacityValue = cap
                
                self.capacityLabel.text = "0 / \(self.totalCapacityValue)"
                print("\(cap)")
                // Extract the found value
                //print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
//        // Get the value of the capacity for the manager
//        totalCapacityValue = cap
//
//        capacityLabel.text = "0 / \(totalCapacityValue)"
        lineLabel.text = "0"
        
    }
    
    // Increment capacity value if addition symbol is pressed
    @IBAction func incrementCap(_ sender: UIButton) {
        // Make sure capacity value is less than total capacity value
        if capacityValue < totalCapacityValue {
            // Increment the value
            capacityValue += 1
            
            // Update the capacity value in the database
            let docRef = database.collection("managers").document("\(userName)")
            
            docRef.updateData([
                "currentCapacity": "\(capacityValue)"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            if lineValue > 0 {
                lineValue -= 1
                docRef.updateData([
                    "currentLine": "\(lineValue)"
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                lineLabel.text = String(lineValue)
            }
        }
        
        
        capacityLabel.text = String(capacityValue) + " / \(totalCapacityValue)"
    }
    
    @IBAction func decrementCap(_ sender: UIButton) {
        let docRef = database.collection("managers").document("\(userName)")
        // Make sure capacity is not less than 0
        if capacityValue > 0 {
            // Decrement the value
            capacityValue -= 1
            
            docRef.updateData([
                "currentCapacity": "\(capacityValue)"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
        capacityLabel.text = String(capacityValue) + " / \(totalCapacityValue)"
    }
    
    @IBAction func incrementLine(_ sender: UIButton) {
        // Increment the value
        lineValue += 1
        let docRef = database.collection("managers").document("\(userName)")
        docRef.updateData([
            "currentLine": "\(lineValue)"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        lineLabel.text = String(lineValue)
    }
    
    @IBAction func decrementLine(_ sender: UIButton) {
        let docRef = database.collection("managers").document("\(userName)")
        // Make sure line value is greater than
        if lineValue > 0 {
            docRef.updateData([
                "currentLine": "\(lineValue)"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            lineValue -= 1
        }
        
        lineLabel.text = String(lineValue)
    }
}
