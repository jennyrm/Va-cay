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
    
    // MARK: - Functions
    func updateViews(){
        guard let checklistItem = checklistItem else {return}
        for (key, value) in checklistItem {
            checkListNameLabel.text = key ?? ""
            if value {
                
            }
        }
    }
    
}//End of class
