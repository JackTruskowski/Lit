//
//  VenueModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation
import MapKit

class Venue {
    var name: String?
    var address: String? // maybe this will be location when we use mapkit
    var location: CLLocation?
    var capacity: Int?
    var manager: User?
    var events : [Event] = []
    
    //functions
    init(venueName: String, venueAddress: String, venueCapacity: Int, creator: User) {
        name = venueName
        address = venueAddress
        capacity = venueCapacity
        manager = creator
    }
    
    init() {
        
    }
    
    func addEvent(event: Event) {
        events.append(event)
    }
    

}