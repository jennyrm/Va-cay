//
//  FlightArrivalCalendarViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/4/21.
//

import UIKit

class FlightArrivalCalendarViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var flightArrivalDatePicker: UIDatePicker!
    
    //MARK: - Properties
    var flightArrival: Date?
    weak var delegate: DatePickerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    @IBAction func flightArrivalDatePickerChanged(_ sender: UIDatePicker) {
        flightArrival = flightArrivalDatePicker.date
        delegate?.dateSelected(flightArrival)
        ItineraryController.sharedInstance.itineraryData["flightArrival"] = flightArrival
    }
    
    //MARK: - Functions
    func updateView() {
        if let flightArrival = ItineraryController.sharedInstance.itineraryData["flightArrival"] as? Date {
            flightArrivalDatePicker.date = flightArrival
        }
    }

}//End of class
