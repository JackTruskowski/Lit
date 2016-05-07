//
//  EventModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class Event: CustomStringConvertible{
    
    //required vars upon initialization
    var title: String
    var summary: String
    var host: User
    var venue: Venue
    
    //optional vars
    var startTime: NSDate
    var endTime: NSDate
    var attendanceCount : Int
    var attendees : [User] = []
    
    var description: String{
        get{
            return title
        }
    }

    
    
    //functions
    init(eventTitle: String, eventStartTime: NSDate, eventEndTime: NSDate, eventSummary: String, eventVenue: Venue, eventHost: User){
        
        title = eventTitle
        startTime = eventStartTime
        endTime = eventEndTime
        summary = eventSummary
        venue = eventVenue
        host = eventHost
        attendanceCount = 0
    }
    
    //returns a boolean of whether or not the user is at the event
    func userIsAttending(person: User?)->Bool{
        if person != nil{
            for i in 0 ..< attendees.count {
                if person!.uniqueID == attendees[i].uniqueID {
                    return true
                }
            }
        }
        return false
    }
    
    func addAttendee(person: User?){
        //ensure the user hasn't already checked in (will this be necessary?)
        if person != nil{
        for i in 0 ..< attendees.count {
            if person!.uniqueID == attendees[i].uniqueID {
                print("failed to add attendee")
                return
            }
        }
        print("added attendee")
        attendees.append(person!)
        attendanceCount += 1
        }
    }
    
    func removeAttendee(person: User?){
        if person != nil{
            //loop thru and find the user
            for i in 0 ..< attendees.count {
                if person!.uniqueID == attendees[i].uniqueID {
                    attendees.removeAtIndex(i)
                    attendanceCount -= 1
                    return
                }
            }
        }
    }
}
