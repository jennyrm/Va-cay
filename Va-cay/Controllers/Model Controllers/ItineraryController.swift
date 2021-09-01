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
    var itineraryToEdit: Itinerary?
    var editingItinerary = false
    var sortByBool = false
    var sortAlphabeticalTitle = "A-Z"
    
    //MARK: - Reference to DB
    let db = Firestore.firestore()
    
    //MARK: - CRUD Functions
    func createItinerary(userId: String) {
        let id = UUID().uuidString
        itineraryData["id"] = id
        
        let itineraryReference = db.collection("users").document(userId).collection("itineraries").document(id)
        itineraryReference.setData(itineraryData)
    }
    
    func fetchItineraries(userId: String, completion: @escaping (Bool) -> Void) {
        // JAMLEA: Create Itinerary placeholder while awaiting fetch to complete
        var fetchedItineraries: [Itinerary] = []
        
        db.collection("users").document(userId).collection("itineraries").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let itineraryData = doc.data()
                    
                    //Part 1
                    let destinationCoordinates = itineraryData["destinationCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let tripName = itineraryData["tripName"] as? String ?? ""
                    let tripDate = itineraryData["tripDate"] as? Timestamp ?? nil
                    let tripImage = itineraryData["tripImage"] as? Data ?? Data()
                    //Part 2
                    let flightArrival = itineraryData["flightArrival"] as? Timestamp ?? nil
                    let flightDeparture = itineraryData["flightDeparture"] as? Timestamp ?? nil
                    let hotelAirbnb = itineraryData["hotelAirbnb"] as? String ?? ""
                    let hotelAirbnbCoordinates = itineraryData["hotelAirbnbCoordinates"] as? [ [String?? : [Double] ] ] ?? []
                    let budget = itineraryData["budget"] as? String ?? ""
                    let checklist = itineraryData["checklist"] as? [ [String?? : Bool] ] ?? []
                    //Part 3
                    let activities = itineraryData["activities"] as? [ [ String : [String] ] ] ?? nil
                    let activitiesCoordinates = itineraryData["activitiesCoordinates"] as? [ [String : [String?? : [Double] ] ] ] ?? []
                    //itinerary document id
                    let id = doc.documentID
                   
                    let retrievedItinerary = Itinerary(destinationCoordinates: destinationCoordinates, tripName: tripName, tripDate: tripDate?.dateValue(), tripImage: tripImage, flightArrival: flightArrival?.dateValue(), flightDeparture: flightDeparture?.dateValue(), hotelAirbnb: hotelAirbnb, hotelAirbnbCoordinates: hotelAirbnbCoordinates, budget: budget, checklist: checklist, activities: activities, activitiesCoordinates: activitiesCoordinates, id: id)
                    
                    fetchedItineraries.append(retrievedItinerary)
                }
                // JAMLEA: Overwrite itineraries vaariable with fetched itineraries
                self.itineraries = fetchedItineraries
                fetchedItineraries = []
                
                completion(true)
            }
        }
    }
    
    func editItinerary(userId: String, itinerary: Itinerary, completion: @escaping (Bool) -> Void) {
        let itineraryRef = db.collection("users").document(userId).collection("itineraries").document(itinerary.id)
        
        itineraryRef.setData(itineraryData)
        
        completion(true)
    }
    
    // JAMLEA: Used for updating location from UserFeedVC
    func editDestinationCoordinates(userId: String, itinerary: Itinerary, coords: [[String?? : [Double]]], completion: @escaping (Bool) -> Void) {
        guard let index = itineraries.firstIndex(of: itinerary) else {return}
        
        db.collection("users").document(userId).collection("itineraries").document(itinerary.id).setData(["destinationCoordinates" : coords], merge: true)
        
        itineraries[index].destinationCoordinates = coords
        
        completion(true)
    }
    
    func editChecklist(userId: String, itinerary: Itinerary, checklist: [ [String?? : Bool] ], completion: @escaping (Bool) -> Void) {
        guard let index = itineraries.firstIndex(of: itinerary) else {return}
        
        itineraryData["checklist"] = checklist
        
        db.collection("users").document(userId).collection("itineraries").document(itinerary.id).setData(
            ["checklist" : checklist], merge: true)
        
        itineraries[index].checklist = checklist
        
        completion(true)
    }
    
    func deleteItinerary(userId: String, itinerary: Itinerary, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).collection("itineraries").document(itinerary.id).delete() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("\(itinerary.tripName) has been removed")
                completion(true)
            }
        }
    }
    
    func setItineraryData(itinerary: Itinerary) {
        itineraryData["destinationCoordinates"] = itinerary.destinationCoordinates
        itineraryData["tripName"] = itinerary.tripName
        itineraryData["tripDate"] = itinerary.tripDate
        itineraryData["tripImage"] = itinerary.tripImage
        itineraryData["flightArrival"] = itinerary.flightArrival
        itineraryData["flightDeparture"] = itinerary.flightDeparture
        itineraryData["hotelAirbnb"] = itinerary.hotelAirbnb
        itineraryData["hotelAirbnbCoordinates"] = itinerary.hotelAirbnbCoordinates
        itineraryData["budget"] = itinerary.budget
        itineraryData["checklist"] = itinerary.checklist
        itineraryData["activitiesCoordinates"] = itinerary.activitiesCoordinates
        itineraryData["activities"] = itinerary.activities
        itineraryData["id"] = itinerary.id
    }
    
}//End of class
