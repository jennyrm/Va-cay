//
//  Itinerary.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/1/21.
//

import UIKit

class Itinerary {
    
    //MARK: - Properties
    ///tripDetailsVC
    let destinationCoordinates: [String?? : (Double, Double)]?
    let tripName: String?
    let tripDate: Date?
    let tripImage: UIImage?
    ///itineraryDetailsVC
    let flightArrival: Date?
    let flightDeparture: Date?
    let hotelAirbnb: String?
    let hotelAirbnbCoordinates: [String?? : (Double, Double)]?
    let budget: String?
    let checklist: [String]
    ///activityDetailsVC
    let day: Date?
    let activities: [String]
    let activitiesCoordinates: [String?? : (Double, Double)]?
    let costOfActivities: String?

    init(destinationCoordinates: [String?? : (Double, Double)]?,
        tripName: String?,
        tripDate: Date? = Date(),
        tripImage: UIImage? = UIImage(),
        
        flightArrival: Date? = Date(),
        flightDeparture: Date? = Date(),
        hotelAirbnb: String?,
        hotelAirbnbCoordinates: [String?? : (Double, Double)]?,
        budget: String?,
        checklist: [String],
        
        day: Date? = Date(),
        activities: [String] = [],
        activitiesCoordinates: [String?? : (Double, Double)]? = [:],
        costOfActivities: String? = "")
    {
        self.destinationCoordinates = destinationCoordinates
        self.tripName = tripName
        self.tripDate = tripDate
        self.tripImage = tripImage
        
        self.flightArrival = flightArrival
        self.flightDeparture = flightDeparture
        self.hotelAirbnb = hotelAirbnb
        self.hotelAirbnbCoordinates = hotelAirbnbCoordinates
        self.budget = budget
        self.checklist = checklist
        
        self.day = day
        self.activities = activities
        self.activitiesCoordinates = activitiesCoordinates
        self.costOfActivities = costOfActivities
    }
    
}//End of class
