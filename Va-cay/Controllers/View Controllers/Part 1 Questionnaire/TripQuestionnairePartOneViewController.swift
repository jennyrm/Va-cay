//
//  TripQuestionnairePartOneViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/27/21.
//

import UIKit

protocol updateImageView: AnyObject {
    func updateImage(image: UIImage)
}

class TripQuestionnairePartOneViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDateLabel: UILabel!
    
    //MARK: - Properties
    var tripImage: UIImage?
    
    static weak var delegate: updateImageView?
    
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
        if let tripName = ItineraryController.sharedInstance.itineraryData["tripName"] as? String {
            tripNameTextField.text = tripName
        }
        if let tripDate = ItineraryController.sharedInstance.itineraryData["tripDate"] as? Date {
            tripDateLabel.text = tripDate.formatToString()
        }
        if let tripImage = ItineraryController.sharedInstance.itineraryData["tripImage"] as? UIImage {
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
        if segue.identifier == "toTripQuestionnairePartTwoVC" {
            guard let destinationVC = segue.destination as? TripQuestionnairePartTwoViewController else { return }
//            destinationVC.itinerary = itinerary
            saveTextFieldInputs()
        }
        if segue.identifier == "toTripCalendarVC" {
            guard let destinationVC = segue.destination as? TripCalendarViewController else { return }
            destinationVC.delegate = self
            if ItineraryController.sharedInstance.isEditing {
                
            }
        }
    }
    
    func saveTextFieldInputs() {
        guard let tripName = tripNameTextField.text, !tripName.isEmpty else { return presentErrorAlert(title: "Error", message: "Name of Trip field must not be empty.") }
        ItineraryController.sharedInstance.itineraryData["tripName"] = tripNameTextField.text
        if tripImage != nil {
            let imageData = tripImage?.jpegData(compressionQuality: 0.5)
            ItineraryController.sharedInstance.itineraryData["tripImage"] = imageData
        }
    }
    
}//End of class

//MARK: - Extensions
extension TripQuestionnairePartOneViewController: MediaSelectorDelegate {
    func mediaPickerSelected(image: UIImage) {
        self.tripImage = image
    }
}//End of extension

extension TripQuestionnairePartOneViewController: DatePickerDelegate {
    func dateSelected(_ date: Date?) {
        tripDateLabel.text = date?.formatToString()
    }
}//End of extension

