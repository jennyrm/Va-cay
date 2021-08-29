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
    @IBOutlet weak var showSortButton: UIButton!
    @IBOutlet weak var sortAlphabetButton: UIButton!
    @IBOutlet weak var sortDateButton: UIButton!
    
    //MARK: - Properties
    var indexPathRow: Int?
    var sortAlphabeticalTitle = "A-Z"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForLoggedIn()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sortAlphabetButton.isHidden = true
        sortDateButton.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ItineraryController.sharedInstance.itineraries = []
        ItineraryController.sharedInstance.itineraryData = [:]
        ItineraryController.sharedInstance.editingItinerary = false
        fetchData()
    }
    
    //MARK: - Actions
    @IBAction func showSortButton(_ sender: UIButton) {
        sortAlphabetButton.isHidden.toggle()
        sortDateButton.isHidden.toggle()
    }
    @IBAction func sortItinerariesAlphabetically(_ sender: UIButton) {
        if sortAlphabeticalTitle == "A-Z" {
            let sortedItinerariesByAtoZ = ItineraryController.sharedInstance.itineraries.sorted {
                return $0.tripName.lowercased() < $1.tripName.lowercased()
            }
            
            ItineraryController.sharedInstance.itineraries = sortedItinerariesByAtoZ
            
            sortAlphabeticalTitle = "Z-A"
            sortAlphabetButton.setTitle(sortAlphabeticalTitle, for: .normal)
        } else {
            let sortedItinerariesByZtoA = ItineraryController.sharedInstance.itineraries.sorted {
                return $0.tripName.lowercased() > $1.tripName.lowercased()
            }
            
            ItineraryController.sharedInstance.itineraries = sortedItinerariesByZtoA
            
            sortAlphabeticalTitle = "A-Z"
            sortAlphabetButton.setTitle(sortAlphabeticalTitle, for: .normal)
        }
        
        tableView.reloadData()
    }
    @IBAction func sortItinerariesByDate(_ sender: UIButton) {
        let datedItineraries = ItineraryController.sharedInstance.itineraries.filter {
            return $0.tripDate != nil
        }
        let nonDatedItineraries = ItineraryController.sharedInstance.itineraries.filter {
            return $0.tripDate == nil
        }
        
        if sender.currentImage == UIImage(systemName: "arrow.up") {
            var sortedItinerariesByNewestDate = datedItineraries.sorted {
                return $0.tripDate! < $1.tripDate!
            }
            sortedItinerariesByNewestDate.append(contentsOf: nonDatedItineraries)
            
            ItineraryController.sharedInstance.itineraries = sortedItinerariesByNewestDate
            
            sender.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        } else {
            var sortedItinerariesByOldestDate = datedItineraries.sorted {
                return $0.tripDate! > $1.tripDate!
            }
            sortedItinerariesByOldestDate.append(contentsOf: nonDatedItineraries)

            ItineraryController.sharedInstance.itineraries = sortedItinerariesByOldestDate
            
            sender.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        }
        
        tableView.reloadData()

//        ItineraryController.sharedInstance.itineraries = sortedItinerariesByRecentDate

    }
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
        ItineraryController.sharedInstance.itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as? ItineraryTableViewCell else { return UITableViewCell() }
        
        let itinerary = ItineraryController.sharedInstance.itineraries[indexPath.row]
        cell.itinerary = itinerary
        cell.row = indexPath.row
        cell.delegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
    // JAMLEA: YO JENNY ASK ME ABOUT THIS A WEIRD BUG BETWEEN THE TWO
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
//            let confirmDeleteController = UIAlertController(title: "Delete Itinerary", message: "Are you sure you want to delete this itinerary", preferredStyle: .alert)
//
//            let itinerary = ItineraryController.sharedInstance.itineraries[indexPath.row]
//
//            let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { action in
//                DispatchQueue.main.async {
//                    ItineraryController.sharedInstance.deleteItinerary(userId: UserController.shared.user!.userId, itinerary: itinerary) { result in
//                        switch result {
//                        case true:
////                            self.tableView.deleteRows(at: [indexPath], with: .fade)
//                            self.tableView.reloadData()
//                        case false:
//                            print("error deleting itinerary")
//                        }
//                    }
//                }
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//
//            confirmDeleteController.addAction(confirmAction)
//            confirmDeleteController.addAction(cancelAction)
//
//            self.present(confirmDeleteController, animated: true)
//        }
//        return [deleteAction]
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}//End of extension

