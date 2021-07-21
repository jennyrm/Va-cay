//
//  dayActivitiesTableViewCell.swift
//  Va-cay
//
//  Created by Jenny Morales on 7/20/21.
//

import UIKit

class dayActivitiesTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var activitiesLabel: UILabel!
    
    //MARK: - Properties
    var day: String? {
        didSet {
            updateView()
        }
    }
    var activities: [String]? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        guard let day = day,
              let activities = activities else { return }
        
        dayLabel.text = day
        
        var activitiesString = ""
        activities.forEach({
            activitiesString.append("•\($0)\n")
        })
        activitiesLabel.text = activitiesString
    }
    
}//End of class
