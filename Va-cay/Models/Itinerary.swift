//
//  Itinerary.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/1/21.
//

import UIKit

class Itinerary {
    
    //MARK: - Properties
    //tripDetailsVC
    var tripName: String?
    let tripDate: Date?
    let tripImage: UIImage?
    //itineraryDetailsVC
    let flightArrival: Date?
    let flightDeparture: Date?
    let hotelAccomodations: String?
    let budget: String?
    let checklist: [String]
    //activityDetailsVC
    let day: Date?
    let activities: [String]
    let costOfActivities: String?

    init(tripName: String? = "", tripDate: Date? = Date(), tripImage: UIImage?, flightArrival: Date? = Date(), flightDeparture: Date? = Date(), hotelAccomodations: String?, budget: String?, checklist: [String] = [], day: Date? = Date(), activities: [String] = [], costOfActivities: String?) {
        self.tripName = tripName
        self.tripDate = tripDate
        self.tripImage = tripImage
        self.flightArrival = flightArrival
        self.flightDeparture = flightDeparture
        self.hotelAccomodations = hotelAccomodations
        self.budget = budget
        self.checklist = checklist
        self.day = day
        self.activities = activities
        self.costOfActivities = costOfActivities
    }
    
}//End of class
