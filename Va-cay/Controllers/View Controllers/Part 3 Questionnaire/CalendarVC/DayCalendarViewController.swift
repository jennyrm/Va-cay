//
//  DayCalendarViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/4/21.
//

import UIKit

class DayCalendarViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var dayDatePicker: UIDatePicker!
    
    //MARK: - Properties
    var day: Date?
    weak var delegate: DatePickerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Actions
    @IBAction func dayDatePickerChanged(_ sender: UIDatePicker) {
        day = dayDatePicker.date
        delegate?.dateSelected(day)
    }
    
    //MARK: - Functions
    func updateView() {
        if let day = ItineraryController.sharedInstance.itineraryData["day"] as? Date {
            dayDatePicker.date = day
        }
    }

}//End of class
