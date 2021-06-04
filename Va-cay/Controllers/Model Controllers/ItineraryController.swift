//
//  ItineraryController.swift
//  Va-cay
//
//  Created by Jenny Morales on 5/26/21.
//

import Foundation
import FirebaseFirestore

class ItineraryController {
    
    //MARK: - Shared Instance
    static let sharedInstance = ItineraryController()
    
    //MARK: - Source of Truth
    var itineraryPlaceholder = [String: Any]()
    var itineraries = [Itinerary]()
    
    //MARK: - Reference to DB
    let db = Firestore.firestore()
    
    //MARK: - CRUD Functions
    func createItinerary(for itinerary: Itinerary) {
        let itineraryToAdd: Itinerary = itinerary
        let itineraryReference = db.collection("itineraries").document("test")
        itineraryReference.setData(["tripName": itineraryToAdd.tripName
//                                         "tripDate": itineraryToAdd.tripDate
                                        ])
        itineraries.append(itineraryToAdd)
    }
    
    
}
