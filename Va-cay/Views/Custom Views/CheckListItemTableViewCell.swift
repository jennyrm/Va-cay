//
//  CheckListItemTableViewCell.swift
//  Va-cay
//
//  Created by James Lea on 8/17/21.
//

import UIKit

class CheckListItemTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var checkListBoolButton: UIButton!
    @IBOutlet weak var checkListNameLabel: UILabel!
    
    // MARK: - Properties
    var checklistItem: [String?? : Bool]? {
        didSet {
            updateViews()
        }
    }
    var index: Int?
    
    // MARK: - Actions
    @IBAction func checklistBoolButtonTapped(_ sender: Any) {
        guard let checklistItem = checklistItem else {return}
        
        for (key, value) in checklistItem {
            if value {
                
            }
        }
        
    }
    
    // MARK: - Functions
    func updateViews(){
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
