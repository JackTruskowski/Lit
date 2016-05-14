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
    var name: String = ""
    var address: String = ""
    var summary: String?
    var events : [Event] = []
    
    //functions
    init(venueName: String, venueAddress: String) {
        name = venueName
        address = venueAddress
        
        
        
        
    }
    
    init() {
        name = "Unknown Name"
        address = "Unknown Address"
    }
    
    
    
    
    
}