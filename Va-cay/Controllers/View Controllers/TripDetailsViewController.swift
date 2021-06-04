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
    }
    
    //MARK: - Outlets
    @IBAction func tripCalendarButtonTapped(_ sender: UIButton) {
        
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
    }
    
}//End of class

//MARK: - Extensions
extension TripDetailsViewController: MediaSelectorDelegate {
    func mediaPickerSelected(image: UIImage) {
//        self.selectedImage = image
    }
}//End of extension
