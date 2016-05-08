//
//  DataModel.swift
//  Lit
//
//  Created by Simon Moushabeck on 5/7/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class LitData {
    var eventsList: [Event] = []
    var venuesList: [Venue] = []
    var currentUser: User?
    
    // add and remove events
    func addEvent(event: Event){
        for i in 0 ..< eventsList.count {
            if event.title == eventsList[i].title{
                print(event.title + "already exists")
                return
            }
        }
        eventsList.append(event)
    }
    
    func deleteEvent(event: Event){
        for i in 0 ..< eventsList.count {
            if event.title == eventsList[i].title {
                eventsList.removeAtIndex(i)
                return
            }
        }
    }
    
    // add and remove venues
    func addVenue(venue: Venue){
        for i in 0 ..< venuesList.count {
            if venue.name == venuesList[i].name{
                print(venue.name + "already exists")
                return
            }
        }
        venuesList.append(venue)
    }
    
    func deleteVenue(venue: Venue){
        for i in 0 ..< venuesList.count {
            if venue.name == venuesList[i].name {
                venuesList.removeAtIndex(i)
                return
            }
        }
    }
}