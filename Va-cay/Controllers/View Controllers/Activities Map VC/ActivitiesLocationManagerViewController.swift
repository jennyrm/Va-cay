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
    
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var coordinates = [ [String?? : (Double, Double)] ]()
    weak var mapPinDelegate: MapPinDropped?
    var arrayOfMapPinTitles = [String]()
    
    //MARK: - Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMapAnnotations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationSearchTableVC = storyboard!.instantiateViewController(withIdentifier: "ActivitiesLocationSearchTableVC") as! ActivitiesLocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTableVC)
        resultSearchController?.searchResultsUpdater = locationSearchTableVC
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Find an activity"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTableVC.mapView = mapView
        locationSearchTableVC.handleMapSearchDelegate = self
        
        loadMapPins()
    }
    
    //MARK: - Actions
    
    @IBAction func getCurrentLocationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
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
        selectedPin = placemark
//        mapView.removeAnnotations(mapView.annotations)
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
        
        mapPinDelegate?.droppedPin(title: annotation.title!)
    }
    
    func saveMapAnnotations() {
        for annotation in mapView.annotations {
            coordinates.append( [annotation.title : (annotation.coordinate.latitude, annotation.coordinate.longitude)] )
        }
        ItineraryController.sharedInstance.itineraryPlaceholder["activitiesCoordinates"] = coordinates
    }
    
    func loadMapPins() {
        if let activitiesCoordinates = ItineraryController.sharedInstance.itineraryPlaceholder["activitiesCoordinates"] as? [ [String?? : (Double, Double)] ] {
            activitiesCoordinates.forEach { coordinate in
                for (key, value) in coordinate {
                    let annotation = MKPointAnnotation()
                    let latitude = value.0
                    let longitude = value.1
                    annotation.title = key as? String
                    annotation.coordinate.latitude = latitude
                    annotation.coordinate.longitude = longitude
                    mapView.addAnnotation(annotation)

                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: center, span: span)
                    mapView.setRegion(region, animated: true)
                }
            }
        }
    }

}//End of extension

