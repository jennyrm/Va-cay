//
//  ItineraryMapPinsLocationManagerViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/10/21.
//

import UIKit
import MapKit

class ItineraryMapPinsLocationManagerViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    
    var itinerary: Itinerary?
    var coordinates = [ [String?? : [Double] ] ]()
    var arrayOfMapPinTitles = [String]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationSearchTableVC()
        loadMapPins()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveMapAnnotations()
    }
    
    //MARK: - Actions
    @IBAction func getCurrentLocationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //MARK: - Functions
    func addLocationSearchTableVC() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationSearchTableVC = storyboard!.instantiateViewController(withIdentifier: "ItineraryMapPinsLocationSearchTableVC") as! ItineraryMapPinsLocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTableVC)
        resultSearchController?.searchResultsUpdater = locationSearchTableVC
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where to?"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTableVC.mapView = mapView
        locationSearchTableVC.handleMapSearchDelegate = self
    }
    
    func loadMapPins() {
        guard let itinerary = itinerary else { return }
        
        if let destinationCoordinates = itinerary.destinationCoordinates?.first {
            var key: String?
            var valuesArr = [Double]()
            
            destinationCoordinates.values.forEach({
                valuesArr.append(contentsOf: $0)
            })
            destinationCoordinates.keys.forEach({
                key = $0 ?? ""
            })
            
            let annotation = MKPointAnnotation()
            let latitude = valuesArr[0]
            let longitude = valuesArr[1]
            annotation.title = key
            annotation.coordinate.latitude = latitude
            annotation.coordinate.longitude = longitude
            mapView.addAnnotation(annotation)
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func saveMapAnnotations() {
        for annotation in mapView.annotations {
            coordinates.append( [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude] ] )
        }
        
        if !coordinates.isEmpty {
            guard let user = UserController.sharedInstance.user,
                  let itinerary = itinerary else {return}
            ItineraryController.sharedInstance.editDestinationCoordinates(userId: user.userId, itinerary: itinerary, coords: coordinates) { result in
                
            }
        }
    }
    
}//End of class

//MARK: - Extensions
extension ItineraryMapPinsLocationManagerViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
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

extension ItineraryMapPinsLocationManagerViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        
        mapView.removeAnnotations(mapView.annotations)
        
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
    }
}//End of extension
