//
//  PatronMap.swift
//  CS275-Final-Project
//
//  Created by Rachel Liston on 10/18/21.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseCore
import FirebaseFirestore

class PatronMapViewController: UIViewController {
    
    var mapView: MKMapView!
    var database: Firestore!
    var barNames = [String]()
    var barInfo = [Any]()
    
    //var mapView: MKMapView()
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
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

    // Set location to be on Church Street in Burlington, Vermont
    let homeLocation = CLLocation(latitude: 44.477690, longitude: -73.212450)
    
    func showBarLocations() {
        let coords = [CLLocationCoordinate2D(latitude: 44.475790, longitude: -73.212870), CLLocationCoordinate2D(latitude: 44.476720, longitude: -73.212390), CLLocationCoordinate2D(latitude: 44.476560, longitude: -73.212350), CLLocationCoordinate2D(latitude: 44.475460, longitude: -73.213820),
            CLLocationCoordinate2D(latitude: 44.476200, longitude: -73.211670),
            CLLocationCoordinate2D(latitude: 44.476980, longitude: -73.211990),
            CLLocationCoordinate2D(latitude: 44.476880, longitude: -73.212790)]
        
            let titles = ["Ruben James", "Akes", "Red Square", "What Ales You", "Club Metronome", "Archives", "Ri Ra's"]
        
            for i in coords.indices {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coords[i]
                annotation.title = titles[i]
                mapView.addAnnotation(annotation)
            }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    // Citation: https://stackoverflow.com/questions/33978455/how-do-i-make-a-pin-annotation-callout-in-swift

    /*class CustomAnnotationView: MKPinAnnotationView {
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            canShowCallout = true
            let rightButton = UIButton(type: .infoLight)
            rightCalloutAccessoryView = rightButton
            
            //rightCalloutAccessoryView = UIButton(type: .infoLight)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }*/
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RubenJamesInfo,
            let annotationView = sender as? MKPinAnnotationView {
            destination.annotation = annotationView.annotation as? MKPointAnnotation
        }
    }*/

    let regionRadius: CLLocationDistance = 200
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Zoom to location on map
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        self.showBarLocations()
        mapView.showsUserLocation = true
        /*mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)*/
        centerMapOnLocation(location: homeLocation)

        print("PatronMapViewController loaded its view.")
        self.showBarLocations()
        database = Firestore.firestore()
        
        let docRef = database.collection("managers")
        
        barNames.append("Bar Name")
        barInfo.append("Info")
        
        database.collection("managers").getDocuments() {
            (QuerySnapshot, err) in
            if let err = err {
                print("error!!!!!!!!")
                return
            }

            for manager in QuerySnapshot!.documents {
                //print("\(manager.documentID)")
                //print("\(manager.documentID) \(manager.data())")
                self.barNames.append(manager.documentID)
                // instance of TableViewController
                var listBars = self.tabBarController?.viewControllers![1] as! TableViewController
                listBars.barNames = self.barNames
                
                self.barInfo.append(manager.data())
                listBars.barInfo = self.barInfo
                //print("\(manager.data())")
                
                //print(self.barNames)
            }
        }
    }
    
}
