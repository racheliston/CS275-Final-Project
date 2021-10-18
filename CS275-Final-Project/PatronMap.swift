//
//  PatronMap.swift
//  CS275-Final-Project
//
//  Created by Rachel Liston on 10/18/21.
//

import UIKit
import MapKit

class PatronMapViewController: UIViewController {
    
    var mapView: MKMapView!
        override func loadView() {
            // Create a map view
            mapView = MKMapView()
            // Set it as *the* view of this view controller
            view = mapView
            
            // Labels for the menu to switch map types
            let segmentedControl
                        = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
                segmentedControl.backgroundColor = UIColor.systemBackground
                segmentedControl.selectedSegmentIndex = 0
                
                // Attach a target-action pair to segmented control
                segmentedControl.addTarget(self,
                                           action: #selector(mapTypeChanged(_:)),
                                           for: .valueChanged)
            
                // idk yet
                segmentedControl.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(segmentedControl)
            
            // Margins
            let topConstraint =
                segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
            let margins = view.layoutMarginsGuide
            let leadingConstraint =
                segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
            let trailingConstraint =
                segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
            
            topConstraint.isActive = true
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true
            
        }
    
        // Function to switch map types
        @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
            switch segControl.selectedSegmentIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .hybrid
            case 2:
                mapView.mapType = .satellite
            default:
        break }
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            print("PatronMapViewController loaded its view.")
        }
    
}
