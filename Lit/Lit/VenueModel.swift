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
    var name: String = "no name"
    var address: String = "no address"
    var summary: String?
    var ID = -1
    var events : [Event] = []
    
    //functions
    init(venueName: String, venueAddress: String, venueID: Int) {
        name = venueName
        address = venueAddress
        ID = venueID
    }
}