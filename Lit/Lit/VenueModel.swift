//
//  VenueModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation
import MapKit

class Venue: Hashable {
    var name: String?
    var address: String? // maybe this will be location when we use mapkit
    var location: CLLocation?
    var capacity: Int?
    var manager: User?
    var events : [Event] = []
    
    //Venue class conforms to protocol Hashable
    var hashValue: Int {
        get {
            return "\(name)\(address)".hashValue
        }
    }
    
    //functions
    init(venueName: String, venueAddress: String, venueCapacity: Int, creator: User) {
        name = venueName
        address = venueAddress
        capacity = venueCapacity
        manager = creator
    }
    
    init() {
        name = "New Venue"
        address = "New Address"
    }
    
    func addEvent(event: Event) {
        events.append(event)
    }
    

}

//Venue also conforms to protocol Equatable (needed for a class to be Hashable)
func == (lhs: Venue, rhs: Venue) -> Bool {
    return lhs.hashValue == rhs.hashValue
}