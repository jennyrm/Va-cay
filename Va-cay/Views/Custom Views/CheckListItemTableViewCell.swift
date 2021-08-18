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
    @IBOutlet weak var checkListName: UILabel!
    
    // MARK: - Properties
    var check: [String : Bool]? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    func updateViews(){
        
    }
    
    @objc func yea(){

    }
    
}//End of class
