//
//  DataModel.swift
//  Lit
//
//  Created by Simon Moushabeck on 5/7/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation


class LitData {
    var eventsList: [Int:Event] = [:]
    var venuesList: [Int:Venue] = [:]
    var currentUser: User?
    
    // add and remove events
    func addEvent(event: Event){
        if eventsList[event.ID] == nil {
            eventsList[event.ID] = event
        }
    }
    
    func deleteEvent(event: Event){
        eventsList[event.ID] = nil
    }
    
    // add and remove venues
    func addVenue(venue: Venue){
        if venuesList[venue.ID] == nil{
            venuesList[venue.ID] = venue
        }
    }
    
    func deleteVenue(venue: Venue){
        venuesList[venue.ID] = nil
    }
}