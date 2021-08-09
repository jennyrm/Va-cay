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
    var itinToEdit: Itinerary?
    var isEditing = false
    
    //MARK: - Reference to DB
    let db = Firestore.firestore()
    
    //MARK: - CRUD Functions
    func createItinerary(userId: String) {
        let id = UUID().uuidString
        itineraryData["id"] = id
        let itineraryReference = db.collection("users").document(userId).collection("itineraries").document(id)
        itineraryReference.setData(itineraryData)
    }
    
//    func editItinerary(userId: String, ItineraryId)
    
    func fetchItineraries(userId: String, completion: @escaping (Bool) -> Void) {
        var itinerariesPlaceholder: [Itinerary] = []
        db.collection("users").document(userId).collection("itineraries").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let itineraryData = doc.data()
                    
                    let destinationCoordinates = itineraryData["destinationCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let tripName = itineraryData["tripName"] as? String ?? ""
                    let tripDate = itineraryData["tripDate"] as? Timestamp ?? nil
                    let tripImage = itineraryData["tripImage"] as? Data ?? Data()
                    
                    let flightArrival = itineraryData["flightArrival"] as? Timestamp ?? nil
                    let flightDeparture = itineraryData["flightDeparture"] as? Timestamp ?? nil
                    
                    let hotelAirbnb = itineraryData["hotelAirbnb"] as? String ?? ""
                    let hotelAirbnbCoordinates = itineraryData["hotelAirbnbCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let budget = itineraryData["budget"] as? String ?? ""
                    let checklist = itineraryData["checklist"] as? [String] ?? []
                    
                    let dayCounter = itineraryData["dayCounter"] as? Int ?? 1
                    let activities = itineraryData["activities"] as? [ [ String : [String] ] ] ?? nil
                    let activitiesCoordinates = itineraryData["activitiesCoordinates"] as? [ [String?? : [Double] ] ] ?? []
//                    let costOfActivities = itineraryData["costOfActivities"] as? [String] ?? []
                    
                    let id = doc.documentID
                   
                    let retrievedItinerary = Itinerary(destinationCoordinates: destinationCoordinates, tripName: tripName, tripDate: tripDate?.dateValue(), tripImage: tripImage, flightArrival: flightArrival?.dateValue(), flightDeparture: flightDeparture?.dateValue(), hotelAirbnb: hotelAirbnb, hotelAirbnbCoordinates: hotelAirbnbCoordinates, budget: budget, checklist: checklist, dayCounter: dayCounter, activities: activities, activitiesCoordinates: activitiesCoordinates, id: id)
                    
                    itinerariesPlaceholder.append(retrievedItinerary)
                }
                self.itineraries = itinerariesPlaceholder
                itinerariesPlaceholder = []
                completion(true)
            }
        }
    }
    
    func editItinerary(userId: String, itinerary: Itinerary, completion: @escaping (Bool) -> Void){
        
        guard let index = itineraries.firstIndex(of: itinerary) else {return}
        
        let itineraryReference = db.collection("users").document(userId).collection("itineraries").document(itinerary.id)
        itineraryReference.setData([
            "destinationCoordinates" : itinerary.destinationCoordinates,
            "tripName" : itinerary.tripName,
            "tripDate" : itinerary.tripDate,
            "tripImage" : itinerary.tripImage,
            "flightArrival" : itinerary.flightArrival,
            "flightDeparture" : itinerary.flightDeparture,
            "hotelAirbnb" : itinerary.hotelAirbnb,
            "hotelAirbnbCoordinates" : itinerary.hotelAirbnbCoordinates,
            "budget" : itinerary.budget,
            "checklist" : itinerary.checklist,
            "dayCounter" : itinerary.dayCounter,
            "activities" : itinerary.activities,
            "activitiesCoordinates" : itinerary.activitiesCoordinates,
//            "costOfActivities" : itinerary.costOfActivities,
            "id" : itinerary.id,
        ])
    
        completion(true)
    }
    
    func deleteItinerary(userId: String, itinerary: Itinerary, completion: @escaping (Bool) -> Void){
        guard let index = itineraries.firstIndex(of: itinerary) else {return}
        
        db.collection("users").document(userId).collection("itineraries").document(itinerary.id).delete() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("\(itinerary.tripName) has been removed")
                self.itineraries.remove(at: index)
                completion(true)
            }
        }
    }
    
}//End of class
