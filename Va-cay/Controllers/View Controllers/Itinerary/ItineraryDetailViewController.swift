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
    var itinerary: Itinerary? {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
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
//        itinerary.days?.forEach({ key in
//            print(key.values.first?[0].keys)
//            print(key.values.first?[0]["day"])
//        })
//        print(itinerary.days)
    }

}//End of class

//MARK: - Extensions
//extension ItineraryDetailViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let itinerary = itinerary {
//            return itinerary.days!.count
//        } else {
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let itinerary = itinerary {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "dayActivityCell")
//            cell?.textLabel?.text = itinerary
//            cell.detailTextLabel.text = itinerar
//            return cell!
//        } else {
//             return UITableViewCell()
//        }
//    }
//}//End of extension
