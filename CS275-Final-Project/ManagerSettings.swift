//
//  ManagerSettings.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 10/18/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import CoreLocation


class ManagerSettingsViewController: UIViewController {
    
    // Create a username variable
    var userName = ""
    var database : Firestore!
    
    // Make a button to change total capacity
    @IBOutlet var totalCapButton: UIButton!
    
    // Make a button to change hours
    @IBOutlet var hoursButton: UIButton!
    
    // Make a button to change address
    @IBOutlet var addressButton: UIButton!
    
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
    
    @IBAction func changeHours(_ sender: Any) {
        
        let cont = UIAlertController(title: "Enter new hours", message: nil, preferredStyle: .alert)
        
        cont.addTextField()
        
        // If the user presses submit, send new capacity to database
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned cont] _ in
            // Get the data
            var hours = ""
            let h = cont.textFields![0].text
            if let c = cont.textFields![0].text, c != "" {
                hours = c
            }
            
            
            // Query the database
            let docRef = self.database.collection("managers").document("\(self.userName)")
            
            docRef.updateData([
                "hours": "\(hours)"
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
    
    @IBAction func changeAddress(_ sender: Any) {
        
        let cont = UIAlertController(title: "Enter Address", message: nil, preferredStyle: .alert)
        
        cont.addTextField { (textField) in
            textField.placeholder = "Street Address"
        }
        
        cont.addTextField { (textField) in
            textField.placeholder = "City"
        }
        
        cont.addTextField { (textField) in
            textField.placeholder = "State"
        }
        
        cont.addTextField { (textField) in
            textField.placeholder = "Zip Code"
        }
        
        // If the user presses submit, send new capacity to database
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned cont] _ in
            // Get the data
            var addressValue = ""
            var cityValue = ""
            var stateValue = ""
            var zipCodeValue = ""
            if let sA = cont.textFields![0].text, sA != "" {
                addressValue = sA
            }
            if let cT = cont.textFields![1].text, cT != "" {
                cityValue = cT
            }
            if let sT = cont.textFields![0].text, sT != "" {
                stateValue = sT
            }
            if let zP = cont.textFields![0].text, zP != "" {
                zipCodeValue = zP
            }
            
            let address = "\(addressValue), \(cityValue), \(stateValue), \(zipCodeValue)"
            
            // https://stackoverflow.com/questions/47244532/converting-a-city-name-to-coordinates-in-swift
            self.getCoordinateFrom(address: address) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
                DispatchQueue.main.async {
                    print(address, "Location:", coordinate)
                    let latitudeReturned = coordinate.latitude
                    let longitudeReturned = coordinate.longitude
                    // Query the database
                    let docRef = self.database.collection("managers").document("\(self.userName)")
                    
                    docRef.updateData([
                        "longitude": "\(longitudeReturned)",
                        "latitude": "\(latitudeReturned)"
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
            
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
    

    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    

}
