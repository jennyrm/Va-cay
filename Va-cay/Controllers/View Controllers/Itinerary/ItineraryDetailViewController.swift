//
//  ItineraryDetailViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/19/21.
//

import UIKit

class ItineraryDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var flightArrivalLabel: UILabel!
    @IBOutlet weak var flightDepartureLabel: UILabel!
    @IBOutlet weak var hotelAirbnbLabel: UILabel!
    @IBOutlet weak var checklistLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var checklist = ""
    var days = [String]()
    var activities = [[String]]()
    var itinerary: Itinerary? {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: -  Actions
    
    //MARK: - Functions
    func updateView() {
        guard let itinerary = itinerary else { return }
        tripNameLabel.text = itinerary.tripName
        tripDateLabel.text = itinerary.tripDate?.formatToString()
        flightArrivalLabel.text = itinerary.flightArrival?.formatToStringWithShortDateAndTime()
        flightDepartureLabel.text = itinerary.flightDeparture?.formatToStringWithShortDateAndTime()
        hotelAirbnbLabel.text = itinerary.hotelAirbnb
        itinerary.checklist?.forEach({
            checklist.append("•\($0)\n")
        })
        checklistLabel.text = checklist
        itinerary.activities?.forEach({ (day) in
            for (key, value) in day {
                days.append(key)
                activities.append(value)
            }
        })
    }
    
}//End of class

//MARK: - Extensions
extension ItineraryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itinerary = itinerary,
              let cell = tableView.dequeueReusableCell(withIdentifier: "dayActivityCell") else { return UITableViewCell() }
        cell.textLabel?.text = days[indexPath.row]
//        cell.detailTextLabel?.text =
        return cell
    }
}//End of extension
