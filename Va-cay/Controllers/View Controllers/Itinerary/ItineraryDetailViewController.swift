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
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var checklist = ""
    var days = [String]()
    var activities = [[String]]()
    var indexPath: Int?
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
        itinerary.activities?.forEach({ (day) in
            for (key, value) in day {
                days.append(key)
                activities.append(value)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let itinerary = itinerary else { return }
        ItineraryController.sharedInstance.editingItinerary = true
        ItineraryController.sharedInstance.itineraryToEdit = itinerary
        
        if segue.identifier == "toHotelAirbnbMapVC" {
            guard let destinationVC = segue.destination as? HotelAirbnbLocationManagerViewController else { return }
            destinationVC.onDetailVC = true
        }
        
        if segue.identifier == "toActivitiesMapVC" {
            guard let destinationVC = segue.destination as? ActivitiesLocationManagerViewController,
                  let indexPath = indexPath else { return }
            
            let dayToSend = days[indexPath]
            let activitiesToSend = activities[indexPath]
            
            destinationVC.onDetailVC = true
            destinationVC.day = dayToSend
            destinationVC.activities = activitiesToSend
        }
        if segue.identifier == "toChecklistVC" {
            guard let destinationVC = segue.destination as? ChecklistModalViewController else {return}
            
            let checklistToSend = itinerary.checklist
            destinationVC.checklist = checklistToSend
            
        }
    }
    
}//End of class

//MARK: - Extensions
extension ItineraryDetailViewController: getIndexPathRow {
    func indexPath(row: Int) {
        self.indexPath = row
    }
}//End of extension

extension ItineraryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayActivityCell") as? dayActivitiesTableViewCell else { return UITableViewCell() }
        
        cell.day = days[indexPath.row]
        cell.activities = activities[indexPath.row]
        cell.row = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Activities"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Copperplate", size: 30.0)
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    // JAMLEA: Deleting activities action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let itinerary = itinerary,
              let user = UserController.shared.user else {return}
        if editingStyle == .delete {
            itinerary.activities?.remove(at: indexPath.row)
            ItineraryController.sharedInstance.itineraryData["activities"] = self.itinerary?.activities
            ItineraryController.sharedInstance.editItinerary(userId: user.userId, itinerary: itinerary) { result in
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}//End of extension

extension ItineraryDetailViewController: updateItinerary {
    func updateItinerary(checklistItem: [String?? : Bool], index: Int) {
        print("hit")
    }
    
}//End of extension
