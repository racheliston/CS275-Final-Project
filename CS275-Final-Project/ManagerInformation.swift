//
//  ManagerInformation.swift
//  CS275-Final-Project
//
//  Created by Sam Pitonyak on 11/10/21.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import CoreLocation

class ManagerInformationViewController: UIViewController {
    
    
    var database: Firestore!
    
    // Create an instance of ManagerCreateAccount
    var userName = ""
    var longitudeReturned = 0.0
    var latitudeReturned = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
        
        
        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    // Set the information for the user including: total capacity, hours, and address
    @IBOutlet var capacity: UITextField!
    @IBOutlet var hours: UITextField!
    @IBOutlet var streetAddress: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zipCode: UITextField!
    @IBOutlet var country: UITextField!
    
    
    
    
    @IBAction func submitInformation(_ sender: Any) {
        
        var capValue = 0
        var hoursValue = ""
        var addressValue = ""
        var cityValue = ""
        var stateValue = ""
        var zipCodeValue = ""
        var countryValue = ""
        
  
        // Set a boolean that is true if any of the fields are empty
        var empty = false
        
        // Create an alert controller in case they leave a field blank
        let alertTextFieldsEmpty = UIAlertController(title: nil,
                                                message: "Please fill out all text fields",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertTextFieldsEmpty.addAction(okAction)
        
        // Make sure the text fields are not empty when pressed
        if let c = capacity.text, c != "" {
            capValue = Int(c)!
        } else {
            empty = true
        }
        
        if let h = hours.text, h != "" {
            hoursValue = h
        } else {
            empty = true
        }
        
        if let sA = streetAddress.text, sA != "" {
            addressValue = sA
        } else {
            empty = true
        }
        if let cT = city.text, cT != "" {
            cityValue = cT
        } else {
            empty = true
        }
        if let sT = state.text, sT != "" {
            stateValue = sT
        } else {
            empty = true
        }
        if let zP = zipCode.text, zP != "" {
            zipCodeValue = zP
        } else {
            empty = true
        }
        if let cR = country.text, cR != "" {
            countryValue = cR
        } else {
            empty = true
        }
        
        // If empty is true, display an alert controller telling them their fields cannot be empty
        if empty {
            present(alertTextFieldsEmpty, animated: true, completion: nil)
        } else {
            var address = "\(addressValue), \(cityValue), \(stateValue), \(zipCodeValue)"
            //var address = "1 Infinite Loop, Cupertino, CA"
            //getCoordinate(addressString: address, completionHandler: completedValue)
            // https://stackoverflow.com/questions/47244532/converting-a-city-name-to-coordinates-in-swift
            getCoordinateFrom(address: address) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
                DispatchQueue.main.async {
                    print(address, "Location:", coordinate)
                    self.latitudeReturned = coordinate.latitude
                    self.longitudeReturned = coordinate.longitude
                    self.database.collection("managers").document("\(self.userName)").setData(["longitude" : "\(self.longitudeReturned)", "latitude" : "\(self.latitudeReturned)"], merge: true)
                }

            }
            
            
            let userName = self.userName
            // Store the information in the account that was created
            database.collection("managers").document("\(userName)").setData([ "capacity" : "\(capValue)", "hours" : "\(hoursValue)", "currentCapacity" : "0", "currentLine" : "0"], merge: true)
            
            print("Data has been written to the database")
            
            // Move the user to the next view controller
            let managerHome = self.storyboard?.instantiateViewController(withIdentifier: "ManagerHomeViewController") as! ManagerHomeViewController
            
            managerHome.userName = self.userName
            
            self.navigationController?.pushViewController(managerHome, animated: true)
            
            
        }
        
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    func completedValue(coordinates: CLLocationCoordinate2D, error : NSError?) -> Void {
        print("Completion placeholder")
    }
    
    
    
    
    
    
}
