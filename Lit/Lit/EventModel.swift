//
//  EventModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class Event{
    
    //required vars upon initialization
    var title: String
    var description: String
    var host: User
    var venue: Venue
    
    //optional vars
    var startTime: NSDate?
    var endTime: NSDate?
    var attendanceCount : Int
    var attendees : [User] = []
    
    
    //functions
    init(eventTitle: String, eventStartTime: NSDate?, eventEndTime: NSDate?, eventDescription: String, eventVenue: Venue, eventHost: User){
        
        title = eventTitle
        startTime = eventStartTime
        endTime = eventEndTime
        description = eventDescription
        venue = eventVenue
        host = eventHost
        attendanceCount = 0
    }
    
    //Receives a change in attendance numbers (ie -1 = one person left) and updates attendanceCount
    func updateAttendance(changeInAttendance : Int){
        if attendanceCount + changeInAttendance > 0 {
            attendanceCount += changeInAttendance
        }else{
            attendanceCount = 0
        }
        
    }
    
    func addAttendee(person: User){
        //ensure the user hasn't already checked in (will this be necessary?)
        for var i = 0; i < attendees.count; ++i {
            if person.uniqueID == attendees[i].uniqueID {
                return
            }
        }
        attendees.append(person)
    }
    
    func removeAttendee(person: User){
        //loop thru and find the user
        for var i = 0; i < attendees.count; ++i {
            if person.uniqueID == attendees[i].uniqueID {
                attendees.removeAtIndex(i)
            }
        }
    }
}
