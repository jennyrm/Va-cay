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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Actions
    
    //MARK: - Functions
    func fetchData() {
        DispatchQueue.main.async {
            ItineraryController.sharedInstance.fetchItineraries { (success) in
                if success {
                    print("Successfully fetched data!!")
                    print(ItineraryController.sharedInstance.itineraries)
                    self.tableView.reloadData()
                } else {
                    print("Firebase didn't return shit")
                }
            }
        }
    }
    
}//End of class

//MARK: - Extensions
extension UserFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ItineraryController.sharedInstance.itineraries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as? ItineraryTableViewCell else { return UITableViewCell() }
        let itinerary = ItineraryController.sharedInstance.itineraries[indexPath.row]
        cell.itinerary = itinerary
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
}//End of extension
