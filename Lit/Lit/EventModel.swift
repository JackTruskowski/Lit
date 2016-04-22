//
//  EventModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class Event{
    
    //variables
    var title: String?
    var startTime: NSDate?
    var endTime: NSDate?
    var description: String?
    var venue: Venue?
    var host: User?
    
    
    //functions
    
    func initWithParams(eventTitle: String, eventStartTime: NSDate?, eventEndTime: NSDate?, eventDescription: String, eventVenue: Venue?, eventHost: User){
        
        title = eventTitle
        startTime = eventStartTime
        endTime = eventEndTime
        description = eventDescription
        venue = eventVenue
        host = eventHost
        
    }
    
    
    
    
}
