//
//  ServerConnect.swift
//  Lit
//
//  Created by Jack Truskowski on 5/6/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit
import WebKit

class Server {
    
    var valuesFromDatabase : NSArray = []
    var mapData: LitData?
    func refreshEventsFromServer(){
        let url = NSURL(string: "http://52.201.225.102/getevent.php")
        let data = NSData(contentsOfURL: url!)
        valuesFromDatabase = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        //repopulate the added events array with events from the server
        mapData?.eventsList.removeAll()
        for i in 0 ..< valuesFromDatabase.count{
            //get all vars
            let hostidstr = String(valuesFromDatabase[i]["HostID"])
            let venueidstr = String(valuesFromDatabase[i]["VenueID"])
            
            //convert to an nsdate object from datetime
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd HH:mm"
            dateFormatter.locale = NSLocale.currentLocale()
            print(valuesFromDatabase[i]["StartTime"]!?.description)
            let starttimedate = dateFormatter.dateFromString(String(valuesFromDatabase[i]["StartTime"]!?.description))
            let endtimedate = dateFormatter.dateFromString(String(valuesFromDatabase[i]["EndTime"]!?.description))
            

            let titlestr = String(valuesFromDatabase[i]["Title"])
            let descriptionstr = String(valuesFromDatabase[i]["Description"])
            print(titlestr)
            print(starttimedate)
            
            //make a sample host TODO: should look up in a host database
            var aHost = User()
            aHost.name = "Unknown"
            aHost.uniqueID = hostidstr
            
            //make a sample venue TODO: should look up in a venue database
            let aVenue = Venue()
            aVenue.name = venueidstr
            
            if(starttimedate == nil || endtimedate == nil){
                print("CONTINUING")
                continue
            }

            //make an event
            let newEvent = Event(eventTitle: titlestr, eventStartTime: starttimedate!, eventEndTime: endtimedate!, eventSummary: descriptionstr, eventVenue: aVenue, eventHost: aHost)
            
            mapData?.eventsList.append(newEvent)
        }
        
    }
    
    func postToServer(anEvent: Event){
        
        let hostidstr = anEvent.host.uniqueID
        let venueidstr = anEvent.venue.name! //TODO: give venues unique IDs
        
        //convert to a datetime object from mysql
        let starttimestr = anEvent.startTime//dateFormatter.stringFromDate(anEvent.startTime)
        print(starttimestr)
        let endtimestr = anEvent.endTime//dateFormatter.stringFromDate(anEvent.endTime)
        let titlestr = anEvent.title
        let descriptionstr = anEvent.description
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.201.225.102/addevent.php")!)
        request.HTTPMethod = "POST"
        let postString = "a=\(hostidstr)&b=\(venueidstr)&c=\(starttimestr)&d=\(endtimestr)&e=\(titlestr)&f=\(descriptionstr)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                print("error=\(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("response = \(responseString)")
        }
        task.resume()
    }
    
    
    func printData(){
        for i in 0 ..< valuesFromDatabase.count{
            print("\(valuesFromDatabase[i]["HostID"])" , "\(valuesFromDatabase[i]["VenueID"])")
        }
    }
    
}
