//
//  MapModel.swift
//  Lit
//
//  Created by Chris MacDonald on 4/26/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class Map {
    
    private var eventsList : [Event]
    private var venuesTable : [Venue: [Event]] //dictionary where key is a Venue and value is a list of Events at that Venue
    
    init () {
        eventsList = []
        venuesTable = [Venue: [Event]]()
    }
    
    func addEvent(event: Event) {
        
        eventsList.append(event)
        if eventsList.isEmpty {
            print("Events list is still empty in Map Model")
        }
        
        print("Events List: \(eventsList)")
        
        if venuesTable[event.venue] == nil {
            venuesTable[event.venue] = [event]
        } else {
            venuesTable[event.venue]!.append(event)
        }
        
        if venuesTable.isEmpty {
            print("TABLE IS STILL EMPTY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        }
        

        
        print("Venues table below:")
        print(venuesTable)
    }
    
    func getVenueEventsCount(venue: Venue) -> Int {
        
        
        print(venuesTable)
        print("VENUES TABLE ABOVE")
        if venuesTable[venue] != nil {
            return (venuesTable[venue]?.count)!
        }
        return 0
    }
    
    func getEventsAtVenue(venue: Venue) -> [Event]? {
      
        return venuesTable[venue]
    }
    
}