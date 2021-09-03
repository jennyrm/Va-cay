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
    var sortByBool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForLoggedIn()
        
        self.view.backgroundColor = Colors.customYellow
        
        tableView.delegate = self
        tableView.dataSource = self
        sortByTableViewCell.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ItineraryController.sharedInstance.itineraries = []
        ItineraryController.sharedInstance.itineraryData = [:]
        ItineraryController.sharedInstance.editingItinerary = false
        fetchData()
    }
    
    //MARK: - Actions
    @IBAction func addItineraryButtonTapped(_ sender: UIButton) {
        ItineraryController.sharedInstance.itineraries = []
    }
    
    //MARK: - Functions
    func fetchData() {
        guard let user = Auth.auth().currentUser else { return }
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
    
    func checkForLoggedIn() {
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
            ItineraryController.sharedInstance.setItineraryData(itinerary: itineraryToSend)
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
        ItineraryController.sharedInstance.itineraries.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath) as? sortByTableViewCell else {return UITableViewCell()}
            cell.index = indexPath.row
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as? ItineraryTableViewCell else { return UITableViewCell() }
            
            let itinerary = ItineraryController.sharedInstance.itineraries[indexPath.row - 1]
            cell.itinerary = itinerary
            cell.row = indexPath.row - 1
            cell.delegate = self
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row > 0 {
            let confirmDeleteController = UIAlertController(title: "Delete Itinerary", message: "Are you sure you want to delete this itinerary?", preferredStyle: .alert)
            
            let itinerary = ItineraryController.sharedInstance.itineraries[indexPath.row]
            
            let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                DispatchQueue.main.async {
                    ItineraryController.sharedInstance.deleteItinerary(userId: UserController.shared.user!.userId, itinerary: itinerary) { result in
                        switch result {
                        case true:
                                self.tableView.reloadData()
                        case false:
                            print("error deleting itinerary")
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            confirmDeleteController.addAction(confirmAction)
            confirmDeleteController.addAction(cancelAction)
            
            self.present(confirmDeleteController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if ItineraryController.sharedInstance.sortByBool {
                return 90
            } else {
                return 30
            }
        } else {
            return 300
        }
    }
}//End of extension

extension UserFeedViewController: sortByTableViewCellDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
}
