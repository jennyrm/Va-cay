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
    var row: Int?
    var itinerary: Itinerary? {
        didSet {
            updateView()
        }
    }
    var delegate: getIndexPathRow?
    
    //MARK: - Actions
    @IBAction func mapPinButtonTapped(_ sender: UIButton) {
        guard let row = row else { return }
        delegate?.indexPath(row: row)
    }
    @IBAction func itineraryButtonTapped(_ sender: UIButton) {
        guard let row = row else { return }
        delegate?.indexPath(row: row)
    }
    
    //MARK: - Functions
    func updateView() {
        guard let itinerary = itinerary else { return }
        destinationLabel.text = itinerary.tripName
        let imageData = itinerary.tripImage
        tripImageView.image = UIImage(data: imageData ?? Data())
    }
    
}//End of class

