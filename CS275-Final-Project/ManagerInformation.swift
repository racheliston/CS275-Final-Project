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
    
    lazy var geoLoc = CLGeocoder()
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
    @IBOutlet var longitude: UITextField!
    @IBOutlet var latitude: UITextField!
    
    
    @IBAction func submitInformation(_ sender: Any) {
        
        var capValue = 0
        var hoursValue = ""
        var
  
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
        
        if let long = longitude.text, long != "" {
            longitudeValue = long
        } else {
            empty = true
        }
        if let lat = latitude.text, lat != "" {
            latitudeValue = lat
        } else {
            empty = true
        }
        
        // If empty is true, display an alert controller telling them their fields cannot be empty
        if empty {
            present(alertTextFieldsEmpty, animated: true, completion: nil)
        } else {
            
            let userName = self.userName
            // Store the information in the account that was created
            database.collection("managers").document("\(userName)").setData([ "capacity" : "\(capValue)", "hours" : "\(hoursValue)", "longitude" : "\(self.longitudeReturned)", "latitude" : "\(self.latitudeReturned)", "currentCapacity" : "0", "currentLine" : "0"], merge: true)
            
            print("Data has been written to the database")
            
            // Move the user to the next view controller
            let managerHome = self.storyboard?.instantiateViewController(withIdentifier: "ManagerHomeViewController") as! ManagerHomeViewController
            
            managerHome.userName = self.userName
            
            self.navigationController?.pushViewController(managerHome, animated: true)
            
            
        }
        
    }
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!

                    
                    self.longitudeReturned = location.coordinate.longitude
                    self.latitudeReturned = location.coordinate.latitude
                    
                    print("Got longitude/latitude values")
                    completionHandler(location.coordinate, nil)

                    return
                }
            }

            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    
    
    
    
    
}
