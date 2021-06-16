//
//  HotelAirbnbLocationManagerViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/6/21.
//

import UIKit
import MapKit


class HotelAirbnbLocationManagerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var coordinates = [ [String?? : [Double] ] ]()
    weak var mapPinDelegate: MapPinDropped?
    
    //MARK: - Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMapAnnotations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationSearchTableVC = storyboard!.instantiateViewController(withIdentifier: "HotelAirbnbLocationSearchTableVC") as! HotelAirbnbLocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTableVC)
        resultSearchController?.searchResultsUpdater = locationSearchTableVC
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Find a Hotel or Airbnb"
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
    
    //MARK: - Functions
    func saveMapAnnotations() {
        for annotation in mapView.annotations {
            coordinates.append( [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude]])
        }
        let title = (mapView.annotations[0].title) as? String
        mapPinDelegate?.droppedPin(title: title ?? "")
        if !coordinates.isEmpty {
            ItineraryController.sharedInstance.itineraryData["hotelAirbnbCoordinates"] = coordinates
            print(coordinates)
        }
    }
    
    func loadMapPins() {
        if let hotelAirbnbCoordinates = ItineraryController.sharedInstance.itineraryData["hotelAirbnbCoordinates"] as? [ [String?? : [Double] ] ] {
            hotelAirbnbCoordinates.forEach { coordinate in
                for (key, value) in coordinate {
                    let annotation = MKPointAnnotation()
                    let latitude = value[0]
                    let longitude = value[1]
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
    
}//End of class

//MARK: - Extensions
extension HotelAirbnbLocationManagerViewController: CLLocationManagerDelegate {
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

extension HotelAirbnbLocationManagerViewController: HandleMapSearch {
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
