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
    
    var valuesFromDatabase : NSArray = []
    var mapData: LitData?
    
    func refreshAllDataFromServer(){
        refreshVenuesFromServer()
        refreshEventsFromServer()
    }
    
    func refreshEventsFromServer(){
        
        print("refreshing events from the server")
        
        let url = NSURL(string: "http://52.201.225.102/getevent.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        //repopulate the added events array with events from the server
        mapData?.eventsList.removeAll()
        
        for i in 0 ..< valuesFromDatabase.count{
            //get all vars
            let hostidstr = valuesFromDatabase[i]["HostID"] as? String
            let venueidstr = valuesFromDatabase[i]["VenueID"] as? String
            
            //location info
            let addresstr = valuesFromDatabase[i]["Address"] as? String
            
            
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
            let starttimedate = dateFormatter.dateFromString(s1)
            let endtimedate = dateFormatter.dateFromString(e1)
            
            //get title and description
            let titlestr = valuesFromDatabase[i]["Title"] as? String
            let descriptionstr = valuesFromDatabase[i]["Description"] as? String
            
            //make a sample host TODO: should look up in a host database
            var aHost = searchDBForUserID(hostidstr!)
            if aHost == nil{
                aHost = User(userName: "Unknown User", ID: "-1")
            }
            
            
            //looks up the venue in the data (should have already been populated from server)
            var aVenue = mapData?.searchForVenueByAddress(addresstr!)
            if aVenue == nil{
                aVenue = Venue()
            }
            
            if(starttimedate == nil || endtimedate == nil){
                print("couldn't find start and end times")
                continue
            }
            
            //make an event
            let newEvent = Event(eventTitle: titlestr!, eventStartTime: starttimedate!, eventEndTime: endtimedate!, eventSummary: descriptionstr!, eventVenue: aVenue!, eventHost: aHost!)
            
            mapData?.eventsList.append(newEvent)
        }
    }
    
    func refreshVenuesFromServer(){
        
        print("refreshing venues from the server")
        
        let url = NSURL(string: "http://52.201.225.102/getvenues.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        mapData?.venuesList.removeAll()
        
        for i in 0 ..< valuesFromDatabase.count{
            //get all vars
            let name = valuesFromDatabase[i]["Name"] as? String
            let address = valuesFromDatabase[i]["Address"] as? String
            let summary = valuesFromDatabase[i]["Summary"] as? String
            
            //make a venue
            if(name != nil && address != nil){
                let venueToAdd = Venue(venueName: name!, venueAddress: address!)
                venueToAdd.summary = summary
                mapData?.venuesList.append(venueToAdd)
            }
        }
    }
    
        
    func postEventToServer(anEvent: Event){
        
        //1. Pull all data from the Event
        
        let hostidstr = anEvent.host.uniqueID
        let venueidstr = anEvent.venue.name //TODO: give venues unique IDs
        
        //convert to a datetime object from mysql
        let starttimestr = anEvent.startTime
        
        let endtimestr = anEvent.endTime
        let titlestr = anEvent.title
        let descriptionstr = anEvent.description
        let address = anEvent.venue.address
        
        print(hostidstr, venueidstr, starttimestr, endtimestr, titlestr, descriptionstr, address)
        
        //2. make the request to the server
        print("posting an event to the server")
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addevent.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(hostidstr)&b=\(venueidstr)&c=\(starttimestr)&d=\(endtimestr)&e=\(titlestr)&f=\(descriptionstr)&g=\(address)"
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
        
        let hostidstr = anEvent.host.uniqueID
        let venueidstr = anEvent.venue.name
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/deleteevent.php")!)
        request.HTTPMethod = "GET"
        let postString = "a=\(hostidstr)&b=\(venueidstr)"
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
        
        let namestr = aUser.name
        let imagestr = aUser.picture?.description //todo: host the image somewhere online?
        
        //convert to a datetime object from mysql
        let idstr = aUser.uniqueID
        let hashedpass = aUser.passwordHash
        
        print("posting a user to the server")
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addhost.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(namestr)&b=\(imagestr)&c=\(hashedpass)&d=\(idstr)"
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
        
        //is this necessary? Not used right now
            
        //2. make the request to the server
        print("Adding a venue to the server")
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addvenue.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(name)&b=\(address)&c=\(summary)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                return
            }
        }
        task.resume()
    }
    
    func searchDBForUserID(userid: String)->User? {
        
        //grab all data -- TODO: optimization could just query the database for the 1 specific user
        let url = NSURL(string: "http://52.201.225.102/gethost.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        for i in 0 ..< valuesFromDatabase.count{
            print("HOST FOUND")
            //get all vars
            let name = valuesFromDatabase[i]["Name"] as? String
            let uniqueid = valuesFromDatabase[i]["UniqueID"] as? String
            print(name, uniqueid)
            //make a user
            if(name != nil && uniqueid != nil && uniqueid == userid){
                print("swaggy")
                let userToReturn = User(userName: name!, ID: uniqueid!)
                return userToReturn
            }
        }
        print("returned nil")
        return nil
    }
    
    
}
