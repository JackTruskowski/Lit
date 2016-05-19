//
//  ServerConnect.swift
//  Lit
//
//  Created by Jack Truskowski on 5/6/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit
import WebKit
import MapKit

class Server {
    
    
    var mapData: LitData?
    
    func refreshAllDataFromServer(){
        refreshVenuesFromServer()
        refreshEventsFromServer()
    }
    
    func refreshEventsFromServer(){
        var valuesFromDatabase : NSArray = []
    
        print("refreshing events from the server")
        
        let url = NSURL(string: "http://52.201.225.102/getevent.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        //repopulate the added events array with events from the server
        mapData?.eventsList.removeAll()
        
        for i in 0 ..< valuesFromDatabase.count{
            print("==================")
            print(valuesFromDatabase)
            print("==================")
            //get ids
            let eventIDstr = valuesFromDatabase[i]["EventID"] as? String
            let hostIDstr = valuesFromDatabase[i]["HostID"] as? String
            let venueIDstr = valuesFromDatabase[i]["VenueID"] as? String
            let eventID = Int(eventIDstr!)
            let hostID = Int(hostIDstr!)
            let venueID = Int(venueIDstr!)
            
            //get title and description
            let eventTitle = valuesFromDatabase[i]["Title"] as? String
            let eventDescription = valuesFromDatabase[i]["Description"] as? String

            //convert to an nsdate object from datetime
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd HH:mm"
            dateFormatter.locale = NSLocale.currentLocale()
            
            //note: making a substring is necessary because for some reason 'Optional()' is saved as part of the string
            let start1 = String(valuesFromDatabase[i]["StartTime"])
            let s1 = start1.substringWithRange(Range<String.Index>(start1.startIndex.advancedBy(14) ..< start1.endIndex.advancedBy(-4)))
            let end1 = String(valuesFromDatabase[i]["EndTime"])
            let e1 = end1.substringWithRange(Range<String.Index>(end1.startIndex.advancedBy(14) ..< end1.endIndex.advancedBy(-4)))
            
            
            //format the dates back to an nsdate object
            let startTimeDate = dateFormatter.dateFromString(s1)
            let endTimeDate = dateFormatter.dateFromString(e1)
            
            if(startTimeDate == nil || endTimeDate == nil){
                print("couldn't find start and end times")
                continue
            }
            
            //lookup host in DataBase
            let aHost = getUser(hostID!)
            if aHost == nil{
                //aHost = User(userName: "Unknown User", ID: -1)
                print("no user found in DB for id \(hostID!)")
                continue
            }
            
            //looks up the venue in the data (should have already been populated from server)
            let aVenue = mapData?.venuesList[venueID!]
            if aVenue == nil{
                //aVenue = Venue()
                print("no venue found for id \(venueID)")
                continue
            }
            
            
            //make an event
            let newEvent = Event(eventTitle: eventTitle!, eventStartTime: startTimeDate!, eventEndTime: endTimeDate!, eventSummary: eventDescription!, eventVenue: aVenue!, eventHost: aHost!, eventID: eventID!)
            
            // add event
            mapData?.addEvent(newEvent)
            aVenue?.events.append(newEvent)
            
        }
    }
    
    func refreshVenuesFromServer(){
        var valuesFromDatabase : NSArray = []
        
        print("refreshing venues from the server")
        
        let url = NSURL(string: "http://52.201.225.102/getvenues.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        mapData?.venuesList.removeAll()
        
        for i in 0 ..< valuesFromDatabase.count{
            //get all vars
            let venueIDstr = valuesFromDatabase[i]["VenueID"] as? String
            let venueID = Int(venueIDstr!)
            let name = valuesFromDatabase[i]["Name"] as? String
            let address = valuesFromDatabase[i]["Address"] as? String
            let summary = valuesFromDatabase[i]["Summary"] as? String
            
            //make a venue
            if(name != nil && address != nil && venueID != nil){
                let venueToAdd = Venue(venueName: name!, venueAddress: address!, venueID: venueID!)
                venueToAdd.summary = summary
                // instead of appending, add to dictionary with ID as key
                mapData?.addVenue(venueToAdd)
            }
        }
    }
    
        
    func postEventToServer(anEvent: Event){
        
        //1. Pull all data from the Event
        
        let hostID = anEvent.host.ID
        let venueID = anEvent.venue.ID
        let eventID = anEvent.ID
        
        //convert to a datetime object from mysql
        let startTime = anEvent.startTime
        let endTime = anEvent.endTime
        let title = anEvent.title
        let description = anEvent.description
        
        print(hostID, venueID, startTime, endTime, title, description)
        
        //2. make the request to the server
        print("posting an event to the server")
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addevent.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(eventID)&b=\(hostID)&c=\(venueID)&d=\(startTime)&e=\(endTime)&f=\(title)&g=\(description)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                return
            }
        }
        task.resume()
    }
    
    //Looks up an event on the server and deletes it
    func deleteEventFromServer(anEvent: Event){
        // NOT WORKING TODO make this work
        // may have to edit deleteevent.php
        
        let eventID = anEvent.ID
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/deleteevent.php")!)
        request.HTTPMethod = "POST" // Should this be post?
        let postString = "a=\(eventID)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                
                return
            }
        }
        task.resume()
    }
    
    //adds a specified user to the UsersTable using addhost.php script
    func postUserToServer(aUser: User){
        
        //1. Pull all data from the User
        let userName = aUser.name
        
        //convert to a datetime object from mysql
        let userID = aUser.ID
        
        print("posting a user to the server")
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addhost.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(userName)&b=\(userID)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if error != nil{
                return
            }
        }
        task.resume()
    }
    
    //adds a specified venue to the VenuesTable using addvenue.php script
    func postVenueToServer(aVenue: Venue){
        
        let name = aVenue.name
        let address = aVenue.address
        let summary = aVenue.summary!
        let venueID = aVenue.ID
            
        //2. make the request to the server
        print("Adding a venue to the server")
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addvenue.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(venueID)&b=\(name)&c=\(address)&d=\(summary)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                return
            }
        }
        task.resume()
    }
    
    func getUser(userID: Int)->User? {
        var valuesFromDatabase : NSArray = []
        //grab all data -- TODO: optimization could just query the database for the 1 specific user
        let url = NSURL(string: "http://52.201.225.102/gethost.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        for i in 0 ..< valuesFromDatabase.count{
            print("HOST FOUND")
            //get all vars
            let name = valuesFromDatabase[i]["Name"] as? String
            let foundIDstr = valuesFromDatabase[i]["UserID"] as? String
            let foundID = Int(foundIDstr!)
            print(name, foundID)
            //make a user
            if(name != nil && foundID != nil && foundID == userID){
                print("swaggy")
                let userToReturn = User(userName: name!, id: userID)
                return userToReturn
            }
        }
        
        print("returned nil")
        return nil
    }
    
    
}
