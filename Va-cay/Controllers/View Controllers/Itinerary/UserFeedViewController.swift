//
//  UserFeedViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/26/21.
//

import UIKit

class UserFeedViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var indexPathRow: Int?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ItineraryController.sharedInstance.itineraries = []
        fetchData()
    }
    
    @IBAction func addItineraryButtonTapped(_ sender: UIButton) {
        ItineraryController.sharedInstance.itineraries = []
    }
    
    //MARK: - Functions
    func fetchData() {
        DispatchQueue.main.async {
            ItineraryController.sharedInstance.fetchItineraries { (success) in
                if success {
                    print("Successfully fetched data!!")
                    self.tableView.reloadData()
                } else {
                    print("Firebase didn't return shit")
                }
            }
        }
    }
    
}//End of class

//MARK: - Extensions
extension UserFeedViewController: getIndexPathRow {
    func indexPath(row: Int) {
        self.indexPathRow = row
    }
}//End of extension

extension UserFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ItineraryController.sharedInstance.itineraries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as? ItineraryTableViewCell else { return UITableViewCell() }
        let itinerary = ItineraryController.sharedInstance.itineraries[indexPath.row]
        cell.row = indexPath.row
        cell.delegate = self
        cell.itinerary = itinerary
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            guard let indexPathRow = self.indexPathRow,
                let destinationVC = segue.destination as? ItineraryMapPinsLocationManagerViewController else { return }
            let itineraryToSend = ItineraryController.sharedInstance.itineraries[indexPathRow]
            destinationVC.itinerary = itineraryToSend
        }
        if segue.identifier == "toItineraryDetailVC" {
            guard let indexPathRow = self.indexPathRow,
                let destinationVC = segue.destination as? ItineraryDetailViewController else { return }
            let itineraryToSend = ItineraryController.sharedInstance.itineraries[indexPathRow]
            destinationVC.itinerary = itineraryToSend
        }
    }
    
}//End of extension

