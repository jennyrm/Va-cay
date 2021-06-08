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
    var tripImage: UIImage?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTextFieldInputs()
    }
    
    //MARK: - Functions
    func updateView() {
        if let tripName = ItineraryController.sharedInstance.itineraryPlaceholder["tripName"] as? String {
            tripNameTextField.text = tripName
        }
        if let tripDate = ItineraryController.sharedInstance.itineraryPlaceholder["tripDate"] as? Date {
            tripDateLabel.text = tripDate.formatToString()
        }
        if let tripImage = ItineraryController.sharedInstance.itineraryPlaceholder["tripImage"] as? UIImage {
            self.tripImage = tripImage
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMediaSelectorVC" {
            guard let destinationVC = segue.destination as? MediaSelectorViewController else { return }
            destinationVC.tripImage = tripImage
            destinationVC.delegate = self
        }
        if segue.identifier == "toItineraryDetailsVC" {
            guard let _ = segue.destination as? ItineraryDetailsViewController else { return }
            saveTextFieldInputs()
        }
        if segue.identifier == "toTripCalendarVC" {
            guard let destinationVC = segue.destination as? TripCalendarViewController else { return }
            destinationVC.delegate = self
        }
    }
    
    func saveTextFieldInputs() {
        if tripNameTextField.text != "" {
            ItineraryController.sharedInstance.itineraryPlaceholder["tripName"] = tripNameTextField.text
        }
        if tripImage != nil {
            ItineraryController.sharedInstance.itineraryPlaceholder["tripImage"] = tripImage
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripDetailsViewController: MediaSelectorDelegate {
    func mediaPickerSelected(image: UIImage) {
        self.tripImage = image
    }
}//End of extension

extension TripDetailsViewController: DatePickerDelegate {
    func dateSelected(_ date: Date?) {
        tripDateLabel.text = date?.formatToString()
    }
}//End of extension
