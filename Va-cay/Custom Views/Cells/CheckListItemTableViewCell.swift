//
//  CheckListItemTableViewCell.swift
//  Va-cay
//
//  Created by James Lea on 8/17/21.
//

import UIKit

protocol CheckListItemViewCellDelegate: AnyObject {
    func updateItinerary(checklistItem: [String?? : Bool], index: Int)
}

class CheckListItemTableViewCell: UITableViewCell {

    // MARK: - Properties
    var checklistItem: [String?? : Bool]? {
        didSet {
            updateViews()
        }
    }
    var index: Int?
    static weak var delegate: CheckListItemViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var checkListBoolButton: UIButton!
    @IBOutlet weak var checkListNameLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func checklistBoolButtonTapped(_ sender: Any) {
        guard let checklistItem = checklistItem,
              let index = index else {return}
        for (key, value) in checklistItem {
            if value {
                self.checklistItem = [key : false]
                CheckListItemTableViewCell.delegate?.updateItinerary(checklistItem: [key : false], index: index)
            } else {
                self.checklistItem = [key : true]
                CheckListItemTableViewCell.delegate?.updateItinerary(checklistItem: [key : true], index: index)
            }
        }
    }
    
    // MARK: - Functions
    func updateViews() {
        guard let checklistItem = checklistItem else {return}
        for (key, value) in checklistItem {
            checkListNameLabel.text = key ?? ""
            if value {
                checkListBoolButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                checkListBoolButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
    
}//End of class
