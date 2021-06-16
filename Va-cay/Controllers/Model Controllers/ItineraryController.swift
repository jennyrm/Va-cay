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
    var itineraryData = [String : Any]()
    var itineraries = [Itinerary]()
    
    //MARK: - Reference to DB
    let db = Firestore.firestore()
    
    //MARK: - CRUD Functions
    func createItinerary() {
        let id = UUID().uuidString
        let itineraryReference = db.collection("itineraries").document(id)
        itineraryReference.setData(itineraryData)
    }
    
    func fetchItineraries(completion: @escaping (Bool) -> Void) {
        db.collection("itineraries").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let itineraryData = doc.data()
                    
                    let destinationCoordinates = itineraryData["destinationCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let tripName = itineraryData["tripName"] as? String ?? ""
                    let tripDate = itineraryData["tripDate"] as? Date ?? Date()
                    let tripImage = itineraryData["tripImage"] as? Data ?? Data()
                    
                    let flightArrival = itineraryData["flightArrival"] as? Date ?? Date()
                    let flightDeparture = itineraryData["flightDeparture"] as? Date ?? Date()
                    
                    let hotelAirbnb = itineraryData["hotelAirbnb"] as? String ?? ""
                    let hotelAirbnbCoordinates = itineraryData["hotelAirbnbCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let budget = itineraryData["budget"] as? String ?? ""
                    let checklist = itineraryData["checklist"] as? [String] ?? []
                    
                    let day = itineraryData["day"] as? Date ?? Date()
                    let days = itineraryData["days"] as? [ [ String : [ [String : Any] ] ] ] ?? []
                    let activities = itineraryData["activities"] as? [String] ?? []
                    let activitiesCoordinates = itineraryData["activitiesCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let costOfActivities = itineraryData["costOfActivities"] as? String ?? ""
                    
                    let id = doc.documentID
                    let createdAtString = itineraryData["createdAt"] as? String ?? ""
                    
                    let dateformatter = ISO8601DateFormatter()
                    let createdAt = dateformatter.date(from: createdAtString)
                    
                    let retrievedItinerary = Itinerary(destinationCoordinates: destinationCoordinates, tripName: tripName, tripDate: tripDate, tripImage: tripImage, flightArrival: flightArrival, flightDeparture: flightDeparture, hotelAirbnb: hotelAirbnb, hotelAirbnbCoordinates: hotelAirbnbCoordinates, budget: budget, checklist: checklist, day: day, days: days, activities: activities, activitiesCoordinates: activitiesCoordinates, costOfActivities: costOfActivities, id: id, createdAt: createdAt ?? Date())
                    
                    self.itineraries.append(retrievedItinerary)
                }
//                let sortItineraryObjectsByDate = self.itineraries.sorted(by: { $0.createdAt < $1.createdAt })
//                self.itineraries = sortItineraryObjectsByDate
                completion(true)
            }
        }
    }
    
}//End of class
