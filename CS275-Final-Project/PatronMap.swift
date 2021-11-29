//
//  PatronMap.swift
//  CS275-Final-Project
//
//  Created by Rachel Liston on 10/18/21.
//

import UIKit
import MapKit
import CoreLocation

class PatronMapViewController: UIViewController {
    
    var mapView: MKMapView!
    
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
        let RJLocation = CLLocationCoordinate2D(latitude: 44.475790, longitude: -73.212870)
        let AkesLocation = CLLocationCoordinate2D(latitude: 44.476720, longitude: -73.212390)
        let RedSquareLocation = CLLocationCoordinate2D(latitude: 44.476560, longitude: -73.212350)
        let AlesLocation = CLLocationCoordinate2D(latitude: 44.475460, longitude: -73.213820)
        
        // Add bars to map
        let rubenJames = MKPointAnnotation()
        rubenJames.coordinate = RJLocation
        rubenJames.title = "RJ's"
        mapView.addAnnotation(rubenJames)
        
        let akes = MKPointAnnotation()
        akes.coordinate = AkesLocation
        akes.title = "Akes"
        mapView.addAnnotation(akes)
        
        let redSquare = MKPointAnnotation()
        redSquare.coordinate = RedSquareLocation
        redSquare.title = "Red Square"
        mapView.addAnnotation(redSquare)
        
        let ales = MKPointAnnotation()
        ales.coordinate = AlesLocation
        ales.title = "Ales"
        mapView.addAnnotation(ales)
    }
    
    // Citation: https://stackoverflow.com/questions/33978455/how-do-i-make-a-pin-annotation-callout-in-swift

    class CustomAnnotationView: MKPinAnnotationView {  // or nowadays, you might use MKMarkerAnnotationView
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
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "RJView", sender: view)
    }
    
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
        
        showBarLocations()
        mapView.showsUserLocation = true
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        centerMapOnLocation(location: homeLocation)

        print("PatronMapViewController loaded its view.")
    }
    
}
