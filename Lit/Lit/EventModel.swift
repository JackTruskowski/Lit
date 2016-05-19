//
//  EventModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class Event: CustomStringConvertible{
    var title: String
    var summary: String?
    var host: User
    var venue: Venue
    var startTime: NSDate
    var endTime: NSDate
    var attendees: [User] = [] //dictionary to eliminate the need for userIsAttending
    var ID = 0
    
    var description: String{
        get{
            return title
        }
    }
    
    init(eventTitle: String, eventStartTime: NSDate, eventEndTime: NSDate, eventSummary: String, eventVenue: Venue, eventHost: User, eventID: Int){
        title = eventTitle
        startTime = eventStartTime
        endTime = eventEndTime
        summary = eventSummary
        venue = eventVenue
        host = eventHost
        ID = eventID
    }
    
    //returns a boolean of whether or not the user is at the event
    func userIsAttending(person: User)->Bool{
        for i in 0 ..< attendees.count {
            if person.ID == attendees[i].ID {
                return true
            }
        }
        return false
    }
    
    func addAttendee(person: User){
        //ensure the user hasn't already checked in (will this be necessary?)
        for i in 0 ..< attendees.count {
            if person.ID == attendees[i].ID {
                print("\(person.name) is already attending \(title)")
                return
            }
        }
        attendees.append(person)
    }
    
    func removeAttendee(person: User){
        //loop thru and find the user
        for i in 0 ..< attendees.count {
            if person.ID == attendees[i].ID {
                attendees.removeAtIndex(i)
                return
            }
        }
    }
}
