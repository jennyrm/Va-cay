//
//  sortByTableViewCell.swift
//  Va-cay
//
//  Created by James Lea on 8/30/21.
//

import UIKit

class sortByTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var sortAZButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}//End of class
