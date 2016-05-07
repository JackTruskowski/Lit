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
    var manager: User?
    var events : [Event] = []
    
    //functions
    init(venueName: String, venueAddress: String, creator: User) {
        name = venueName
        address = venueAddress
        manager = creator
    }
    
    init() {
        name = "New Venue"
        address = "New Address"
    }
}