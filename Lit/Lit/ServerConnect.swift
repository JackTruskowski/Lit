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
    
    func refreshEventsFromServer(){
        let url = NSURL(string: "http://52.201.225.102/getevent.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        //repopulate the added events array with events from the server
        addedEvents.removeAll()
        
        for i in 0 ..< valuesFromDatabase.count{
            //get all vars
            let hostidstr = valuesFromDatabase[i]["HostID"] as? String
            let venueidstr = valuesFromDatabase[i]["VenueID"] as? String
            
            var venueloc : CLLocation
            var eventlatitude : Double = 0.0
            var eventlongitude : Double = 0.0
            
            //location info
            if let startlat = (valuesFromDatabase[i]["Latitude"]) as? String{
                eventlatitude = Double(startlat)!
            }
            if let startlong = (valuesFromDatabase[i]["Longitude"]) as? String{
                eventlongitude = Double(startlong)!
            }
            
            if(eventlongitude != 0.0 && eventlatitude != 0.0){
                venueloc = CLLocation(latitude: eventlatitude, longitude: eventlongitude)
            }else{
                continue
            }
            
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
            var aHost = User()
            aHost.name = "Unknown"
            aHost.uniqueID = hostidstr!
            
            //make a sample venue TODO: should look up in a venue database
            let aVenue = Venue()
            aVenue.name = venueidstr
            aVenue.location = venueloc
            
            if(starttimedate == nil || endtimedate == nil){
                continue
            }

            //make an event
            let newEvent = Event(eventTitle: titlestr!, eventStartTime: starttimedate!, eventEndTime: endtimedate!, eventDescription: descriptionstr!, eventVenue: aVenue, eventHost: aHost)
            
            addedEvents.append(newEvent)
        }
        
    }
    
    func postToServer(anEvent: Event){
        
        //1. Pull all data from the Event
        
        let hostidstr = anEvent.host.uniqueID
        let venueidstr = anEvent.venue.name! //TODO: give venues unique IDs
        
        //convert to a datetime object from mysql
        let starttimestr = anEvent.startTime
        
        let endtimestr = anEvent.endTime
        let titlestr = anEvent.title
        let descriptionstr = anEvent.description
        
        //coordinates of the event -- saved as floats in the DB
        let latcoordinate = Float((anEvent.venue.location?.coordinate.latitude)!)
        let longcoordinate = Float((anEvent.venue.location?.coordinate.longitude)!)
        
        //2. make the request to the server
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addevent.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(hostidstr)&b=\(venueidstr)&c=\(starttimestr)&d=\(endtimestr)&e=\(titlestr)&f=\(descriptionstr)&g=\(latcoordinate)&h=\(longcoordinate)"
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
    func deleteFromServer(anEvent: Event){
        
        let hostidstr = anEvent.host.uniqueID
        let venueidstr = anEvent.venue.name!
        
        print(hostidstr, venueidstr)
        
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
}







