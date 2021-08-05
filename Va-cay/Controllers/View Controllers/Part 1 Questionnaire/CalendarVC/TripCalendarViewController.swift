//
//  TripCalendarViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/4/21.
//

import UIKit

class TripCalendarViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tripDatePicker: UIDatePicker!
    
    //MARK: - Properties
    var tripDate: Date?
    weak var delegate: DatePickerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    @IBAction func tripDatePickerChanged(_ sender: UIDatePicker) {
        tripDate = tripDatePicker.date
        delegate?.dateSelected(tripDate)
        
        ItineraryController.sharedInstance.itineraryData["tripDate"] = tripDate
    }
    @IBAction func closeModalCalendarButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func updateView() {
        if let tripDate = ItineraryController.sharedInstance.itineraryData["tripDate"] as? Date {
            tripDatePicker.date = tripDate
        }
    }

}//End of class
