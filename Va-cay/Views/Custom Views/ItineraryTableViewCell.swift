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
    @IBOutlet weak var tripDateLabel: CenterAlignedQuestionnaireLabel!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var itineraryCellStackView: UIStackView!
    @IBOutlet weak var roundedCellEdge: UIView!
    @IBOutlet weak var itineraryBreakBarView: UIView!
    
    //MARK: - Properties
    var itinerary: Itinerary? {
        didSet {
            updateView()
        }
    }
    var row: Int?
    weak var delegate: getIndexPathRow?
    
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
        roundedCellEdge.layer.cornerRadius = 25
        roundedCellEdge.layer.borderWidth = 2
        roundedCellEdge.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        itineraryBreakBarView.layer.cornerRadius = 10
        destinationLabel.text = itinerary.tripName
        let imageData = itinerary.tripImage
        tripImageView.image = UIImage(data: imageData ?? Data())
        guard let tripDate = itinerary.tripDate else {
            tripDateLabel.isHidden = true
            return}
        tripDateLabel.text = tripDate.formatToString()
    }
    
}//End of class

