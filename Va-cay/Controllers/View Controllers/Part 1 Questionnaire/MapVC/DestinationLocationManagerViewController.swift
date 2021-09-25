//
//  LocationManagerViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/26/21.
//

import UIKit
import MapKit
import Lottie

class DestinationLocationManagerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var createItineraryButton: UIButton!
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    var coordinates = [ [String?? : [Double] ] ]()
    var mapPinDelegate: MapPinDropped?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadMapPins()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveMapAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupAnimation()
    }
    
    //MARK: - Actions
    @IBAction func getCurrentLocationButtonTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //MARK: - Functions
    func setupView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationSearchTableVC = storyboard!.instantiateViewController(withIdentifier: "DestinationLocationSearchTableVC") as! DestinationLocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTableVC)
        resultSearchController?.searchResultsUpdater = locationSearchTableVC
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where to?"
//        searchBar.backgroundColor = Colors.mapBackgroundColor
        navigationItem.searchController = resultSearchController
//        navigationController?.navigationBar.barTintColor = Colors.mapBackgroundColor
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTableVC.mapView = mapView
        locationSearchTableVC.handleMapSearchDelegate = self
        
    }
    
    func loadMapPins() {
        if let destinationCoordinates = (ItineraryController.sharedInstance.itineraryData["destinationCoordinates"] as? [ [String?? : [Double] ] ]) {
            destinationCoordinates.forEach { coordinate in
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
    
    func setupAnimation() {
        let planeAnimation = Animation.named("plane5")
        animationView.backgroundColor = Colors.customOffWhite
        animationView.animation = planeAnimation
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.7
        animationView.play()
    }

    func saveMapAnnotations() {
        for annotation in mapView.annotations {
            coordinates.append( [annotation.title : [annotation.coordinate.latitude, annotation.coordinate.longitude] ] )
        }
        if !coordinates.isEmpty {
            ItineraryController.sharedInstance.itineraryData["destinationCoordinates"] = coordinates
        }
    }
    
}//End of class

//MARK: - Extensions
extension DestinationLocationManagerViewController: CLLocationManagerDelegate {
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//
//    }
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
        presentErrorAlert(title: "Error", message: "Please update location access in Settings")
        print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
    }
}//End of extension

extension DestinationLocationManagerViewController: HandleMapSearch {
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

