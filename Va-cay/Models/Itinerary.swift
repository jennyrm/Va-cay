//
//  Itinerary.swift
//  Va-cay
//
//  Created by Jenny Morales on 6/1/21.
//

import UIKit

class Itinerary: Codable {
    
    //MARK: - Properties
    ///TripQuestionnairePart1
    let destinationCoordinates: [ [String?? : [Double] ] ]?
    var tripName: String
    let tripDate: Date?
    let tripImage: Data?
    ///TripQuestionnairePart2
    let flightArrival: Date?
    let flightDeparture: Date?
    var hotelAirbnb: String?
    let hotelAirbnbCoordinates: [ [String?? : [Double] ] ]?
    let budget: String?
    var checklist: [String]?
    ///TripQuestionnairePart3
    let activitiesCoordinates: [ [String?? : [Double] ] ]?
    var activities: [ [ String : [String] ] ]?
    ///ID
    let id: String

    init(destinationCoordinates: [ [String?? : [Double] ] ]?,
        tripName: String,
        tripDate: Date?,
        tripImage: Data?,
        flightArrival: Date?,
        flightDeparture: Date?,
        hotelAirbnb: String?,
        hotelAirbnbCoordinates: [ [String?? : [Double] ] ]?,
        budget: String?,
        checklist: [String]?,

        activities: [ [ String : [String] ] ]?,
        activitiesCoordinates: [ [String?? : [Double] ] ]?,
        id: String)
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

        self.activities = activities
        self.activitiesCoordinates = activitiesCoordinates
        
        self.id = id
    }
    
}//End of class

extension Itinerary: Equatable {
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        lhs.id == rhs.id
    }
}//End of extension
