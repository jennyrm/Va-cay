//
//  ActivitiesLocationManagerViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/7/21.
//

import UIKit
import MapKit


class ActivitiesLocationManagerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getCurrentLocationButton: UIButton!
    
    //MARK: - Properties
    var onDetailVC = false
    
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    weak var mapPinDelegate: MapPinDropped?
    
    var day: String?
    var activities: [String]?
    var activitiesCoordinates =  [ [String : [String?? : [Double] ] ] ]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if !onDetailVC {
            addLocationSearchTableVC()
        } else {
            getCurrentLocationButton.isHidden = true
        }
        
        if let activitiesCoordinates = ItineraryController.sharedInstance.itineraryData["activitiesCoordinates"] as? [ [String : [String?? : [Double] ] ] ] {
            self.activitiesCoordinates = activitiesCoordinates
            loadMapPins()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMapAnnotations()
        onDetailVC = false
        getCurrentLocationButton.isHidden = false
    }
    
    //MARK: - Actions
    @IBAction func getCurrentLocationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //MARK: - Functions
    func addLocationSearchTableVC() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationSearchTableVC = storyboard!.instantiateViewController(withIdentifier: "ActivitiesLocationSearchTableVC") as! ActivitiesLocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTableVC)
        resultSearchController?.searchResultsUpdater = locationSearchTableVC
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Find an activity location"
//        searchBar.backgroundColor = Colors.mapBackgroundColor
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTableVC.mapView = mapView
        locationSearchTableVC.handleMapSearchDelegate = self
    }
    
    func loadMapPins() {
        guard let day = day,
              let activities = activities else { return }
        
        activitiesCoordinates.forEach { activityCoordinates in
            for (key, value) in activityCoordinates {
                if key == day {
                    for (_, activity) in activities.enumerated() {
                        for (title, coordinate) in value {
                            if activity == title!! {
                                let annotation = MKPointAnnotation()
                                let latitude = coordinate[0]
                                let longitude = coordinate[1]
                                annotation.title = title as? String
                                annotation.coordinate.latitude = latitude
                                annotation.coordinate.longitude = longitude
                                mapView.addAnnotation(annotation)
                                
                                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                                let region = MKCoordinateRegion(center: center, span: span)
                                mapView.setRegion(region, animated: true)
                                
                                break
                            }
                        }
                    }
                }
            }
        }
        
        //add code here to center map pin
        //
        //
    }
    
    func saveMapAnnotations() {
        guard let day = day else { return }
        
        //breaks creating itineraries
//        activitiesCoordinates = []
        
        for annotation in mapView.annotations {
            if ItineraryController.sharedInstance.editingItinerary {
                activitiesCoordinates.forEach { activityCoordinates in
                    for (key, _) in activityCoordinates {
                        if key == day {
                            if !activitiesCoordinates.contains([ day : [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude] ] ]) {
                                activitiesCoordinates.append([ day : [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude] ] ])
                            }
                        }
                    }
                }
            } else {
                if !activitiesCoordinates.contains([ day : [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude] ] ]) {
                    activitiesCoordinates.append([ day : [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude] ] ])
                }
            }
        }

        ItineraryController.sharedInstance.itineraryData["activitiesCoordinates"] = activitiesCoordinates
    }
    
}//End of class

//MARK: - Extensions
extension ActivitiesLocationManagerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
    }
}//End of extension

extension ActivitiesLocationManagerViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        guard let day = day else { return }
        
        selectedPin = placemark

        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.name,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        activities?.append(annotation.title!)
        
        mapPinDelegate?.droppedPin(title: annotation.title!, mapDay: day, mapActivities: activities!)
    }
    
}//End of extension
