//
//  ItineraryDetailsViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/27/21.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDateLabel: UILabel!
    
    //MARK: - Properties
//    var selectedImage = UIImage?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Outlets
    @IBAction func tripCalendarButtonTapped(_ sender: UIButton) {
        
    }
    
    //MARK: - Functions
    func updateView() {
        if let tripName = ItineraryController.sharedInstance.itineraryPlaceholder["tripName"] as? String {
            tripNameTextField.text = tripName
        }
        if let tripDate = ItineraryController.sharedInstance.itineraryPlaceholder["tripDate"] as? Date {
            self.tripDateLabel.text = tripDate.formatToString()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMediaSelectorVC" {
            guard let destinationVC = segue.destination as? MediaSelectorViewController else { return }
            destinationVC.delegate = self
        }
        if segue.identifier == "toItineraryDetailsVC" {
            guard let _ = segue.destination as? ItineraryDetailsViewController else { return }
            ItineraryController.sharedInstance.itineraryPlaceholder["tripName"] = tripNameTextField.text
        }
        if segue.identifier == "toTripCalendarVC" {
            guard let destinationVC = segue.destination as? TripCalendarViewController else { return }
            destinationVC.delegate = self
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripDetailsViewController: MediaSelectorDelegate {
    func mediaPickerSelected(image: UIImage) {
//        self.selectedImage = image
    }
}//End of extension

extension TripDetailsViewController: DatePickerDelegate {
    func dateSelected(_ date: Date?) {
        tripDateLabel.text = date?.formatToString()
    }
}//End of extension
