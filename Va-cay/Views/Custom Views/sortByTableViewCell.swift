//
//  sortByTableViewCell.swift
//  Va-cay
//
//  Created by James Lea on 8/30/21.
//

import UIKit

protocol sortByTableViewCellDelegate: AnyObject {
    func reloadTableView()
}

class sortByTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var sortAZButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!
    
    // MARK: - Properties
    static weak var delegate: sortByTableViewCellDelegate?
    var index: Int? {
        didSet {
                updateViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViews()
    }
    // MARK: - Actions
    @IBAction func sortByButtonTapped(_ sender: Any) {
        ItineraryController.sharedInstance.sortByBool.toggle()
        sortByTableViewCell.delegate?.reloadTableView()
    }
    
    @IBAction func alphabeticalButtonTapped(_ sender: Any) {
        if ItineraryController.sharedInstance.sortAlphabeticalTitle == "A-Z" {
            let sortedItinerariesByAtoZ = ItineraryController.sharedInstance.itineraries.sorted {
                return $0.tripName.lowercased() < $1.tripName.lowercased()
            }
            
            ItineraryController.sharedInstance.itineraries = sortedItinerariesByAtoZ
            
            ItineraryController.sharedInstance.sortAlphabeticalTitle = "Z-A"
            sortAZButton.setTitle(ItineraryController.sharedInstance.sortAlphabeticalTitle, for: .normal)
        } else {
            let sortedItinerariesByZtoA = ItineraryController.sharedInstance.itineraries.sorted {
                return $0.tripName.lowercased() > $1.tripName.lowercased()
            }
            ItineraryController.sharedInstance.itineraries = sortedItinerariesByZtoA
            
            ItineraryController.sharedInstance.sortAlphabeticalTitle = "A-Z"
            sortAZButton.setTitle(ItineraryController.sharedInstance.sortAlphabeticalTitle, for: .normal)
        }
        sortByTableViewCell.delegate?.reloadTableView()
    }
    
    @IBAction func upcomingButtonTapped(_ sender: UIButton) {
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
        sortByTableViewCell.delegate?.reloadTableView()
    }
    
    // MARK: - Functions
    func updateViews() {
        sortByButton.tintColor = Colors.customGreen
        if !ItineraryController.sharedInstance.sortByBool {
        sortAZButton.isHidden = true
        upcomingButton.isHidden = true
        } else {
            sortAZButton.isHidden = false
            upcomingButton.isHidden = false
        }
    }
    
}//End of class

