//
//  ItineraryTableViewCell.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/8/21.
//

import UIKit

class ItineraryTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var tripImageView: UIImageView!
    
    //MARK: - Properties
    var itinerary: Itinerary? {
        didSet {
            updateView()
        }
    }
    
    //MARK: - Actions
    
    //MARK: - Functions
    func updateView() {
        guard let itinerary = itinerary else { return }
        destinationLabel.text = itinerary.tripName
        let imageData = itinerary.tripImage
        tripImageView.image = UIImage(data: imageData ?? Data())
    }

}//End of class
