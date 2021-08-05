//
//  FlightDepartureCalendarViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/4/21.
//

import UIKit

class FlightDepartureCalendarViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var flightDepartureDatePicker: UIDatePicker!
    
    //MARK: - Properties
    var flightDeparture: Date?
    weak var delegate: DatePickerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    @IBAction func flightDepartureDatePickerChanged(_ sender: UIDatePicker) {
        flightDeparture = flightDepartureDatePicker.date
        delegate?.dateSelected(flightDeparture)
        ItineraryController.sharedInstance.itineraryData["flightDeparture"] = flightDeparture
    }
    
    @IBAction func dismissModalView(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func updateView() {
        if let flightDeparture = ItineraryController.sharedInstance.itineraryData["flightDeparture"] as? Date {
            flightDepartureDatePicker.date = flightDeparture
        }
    }

}//End of class
