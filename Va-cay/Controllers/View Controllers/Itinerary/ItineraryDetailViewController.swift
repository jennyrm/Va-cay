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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let itinerary = itinerary,
            let destinationVC = segue.destination as? TripQuestionnairePartOneViewController else { return }
        ItineraryController.sharedInstance.isEditing = true
        ItineraryController.sharedInstance.itinToEdit = itinerary
//        destinationVC.itinerary = itinerary
        ItineraryController.sharedInstance.itineraryData["destinationCoordinates"] = itinerary.destinationCoordinates
        ItineraryController.sharedInstance.itineraryData["tripName"] = itinerary.tripName
        ItineraryController.sharedInstance.itineraryData["tripDate"] = itinerary.tripDate
        ItineraryController.sharedInstance.itineraryData["tripImage"] = itinerary.tripImage
        ItineraryController.sharedInstance.itineraryData["flightArrival"] = itinerary.flightArrival
        ItineraryController.sharedInstance.itineraryData["flightDeparture"] = itinerary.flightDeparture
        ItineraryController.sharedInstance.itineraryData["hotelAirbnb"] = itinerary.hotelAirbnb
        ItineraryController.sharedInstance.itineraryData["hotelAirbnbCoordinates"] = itinerary.hotelAirbnbCoordinates
        ItineraryController.sharedInstance.itineraryData["budget"] = itinerary.budget
        ItineraryController.sharedInstance.itineraryData["checklist"] = itinerary.checklist
        ItineraryController.sharedInstance.itineraryData["dayCounter"] = itinerary.dayCounter
        ItineraryController.sharedInstance.itineraryData["activitiesCoordinates"] = itinerary.activitiesCoordinates
        ItineraryController.sharedInstance.itineraryData["activities"] = itinerary.activities
        ItineraryController.sharedInstance.itineraryData["id"] = itinerary.id
    }
    
}//End of class

//MARK: - Extensions
extension ItineraryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayActivityCell") as? dayActivitiesTableViewCell else { return UITableViewCell() }
        cell.day = days[indexPath.row]
        cell.activities = activities[indexPath.row]
        return cell
    }
}//End of extension
