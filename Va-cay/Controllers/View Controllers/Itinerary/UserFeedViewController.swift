//
//  UserFeedViewController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/26/21.
//

import UIKit
import FirebaseAuth

class UserFeedViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var indexPathRow: Int?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//                do {
//                    try Auth.auth().signOut()
//                } catch {
//                    print("Error signing out: %@")
//                }
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(identifier: "AuthVC")
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        }
        guard let user = Auth.auth().currentUser else {return}
        UserController.shared.fetchUser(userId: user.uid) { result in
            switch result {
            case .success(let user):
                UserController.shared.user = user
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ItineraryController.sharedInstance.itineraries = []
        ItineraryController.sharedInstance.itineraryData = [:]
        fetchData()
    }
    
    @IBAction func addItineraryButtonTapped(_ sender: UIButton) {
        ItineraryController.sharedInstance.itineraries = []
    }
    
    //MARK: - Functions
    func fetchData() {
        guard let user = Auth.auth().currentUser else {return}
        DispatchQueue.main.async {
            ItineraryController.sharedInstance.fetchItineraries(userId: user.uid) { result in
                switch result {
                case true:
                    self.tableView.reloadData()
                case false:
                    return
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

