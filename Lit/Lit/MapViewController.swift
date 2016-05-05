//
//  MapViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit
import MapKit

//Todo: better way to store this, maybe hashing of some sort by location
var addedEvents : [Event] = []
var theUser : User?

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    //this hidden view is needed to anchor the popover
    @IBOutlet weak var popoverAnchor: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    //Todo: better way to store this, maybe hashing of some sort by location
    var addedEvents : [Event] = []
    var addedVenues : [Venue] = []
    var theUser : User?
    var map = Map()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapView.delegate = self
        
        //get permission to use location data
        mapView.showsUserLocation = true
        
        
        //hide the settings button if its an ipad
        let deviceIdiom = UIScreen.mainScreen().traitCollection.userInterfaceIdiom
        if deviceIdiom == .Pad{
            settingsButton.title = ""
            settingsButton.enabled = false
        }
        
        //make a sample event from a different user for testing
        let aHost = User()
        let aVenue = Venue(venueName: "Smith Union", venueAddress: "Bowdoin College, 6000 College Station, Brunswick, ME 04011-8451", venueCapacity: 500, creator:  aHost)
        
        aHost.name = "Guy Chill"
        aHost.uniqueID = 2000
        
        //make a sample event for testing
        //aHost.name = "Jack Truskowski"
        //aVenue.name = "Smith Union"
        let aLocation = CLLocation(latitude: 37.781536, longitude: -122.426327)
        aVenue.location = aLocation
        let anEvent = Event(eventTitle: "Club Fair", eventStartTime: nil, eventEndTime: nil, eventDescription: "A fair with clubs", eventVenue: aVenue, eventHost: aHost)
        
        print("Adding event... <<<<<<<<<<<<<<<<<<<< with venue \(aVenue.name)")
        map.addEvent(anEvent)
        addedEvents.append(anEvent)
        
        //make a second event at same location for testing purposes
        
        let aSecondEvent = Event(eventTitle: "Block Party", eventStartTime: nil, eventEndTime: nil, eventDescription: "A party with blocks", eventVenue: aVenue, eventHost: aHost)
        
        map.addEvent(aSecondEvent)
        addedEvents.append(aSecondEvent)
        
        //add some people for testing
        let user1 = User()
        user1.name = "John Doe"
        user1.uniqueID = 1
        let user2 = User()
        user2.name = "Jane Doe"
        user2.uniqueID = 2
        let user3 = User()
        user3.name = "Simon Moushabeck"
        user3.uniqueID = 3
        let user4 = User()
        user4.name = "Chris MacDonald"
        user4.uniqueID = 4
        
        anEvent.addAttendee(user1)
        anEvent.addAttendee(user2)
        anEvent.addAttendee(user3)
        anEvent.addAttendee(user4)
        anEvent.updateAttendance(4)
        
        //read in user defaults
        readInDataFromDefaults()
        
        //refresh right when the view loads
        refreshAnnotations()
    }
    
    //Actions triggered by the user
    @IBAction func zoomToLoc(sender: UIBarButtonItem) {
        panAndZoomToUserLocation()
    }
    
    //get updated event data for their location and populate map
    @IBAction func refreshMapData(sender: UIBarButtonItem) {
        refreshAnnotations()
    }
    
    //add an event to the map (pressing this button should also trigger a popover for adding event info)
    @IBAction func addEvent(sender: UIBarButtonItem) {

        performSegueWithIdentifier("segueToAddEventView", sender: sender)
    }
    
    func initializeUser(aUser : User){
        theUser = aUser
    }
    
    func refreshAnnotations(){
        
        //remove all old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        print(addedEvents.count)
        
        //add all the events to the map as annotations
        for var i = 0; i < addedEvents.count; ++i {
            let coordinates = CLLocationCoordinate2DMake((addedEvents[i].venue.location!.coordinate.latitude), (addedEvents[i].venue.location!.coordinate.longitude))
            let dropPin = MapPin(coordinate: coordinates, title: nil, subtitle: nil, event: addedEvents[i])
            mapView.addAnnotation(dropPin)
        }
    }
    
    //removes an event from the array
    func deleteEvent(anEvent: Event){
        for var i=0; i<addedEvents.count; ++i{
            if addedEvents[i] === anEvent {
                addedEvents.removeAtIndex(i)
            }
        }
    }
    
    
    //TODO: It would be nice to do this immediately, but that causes a crash - the user must click the zoom button for now
    func panAndZoomToUserLocation(){
        
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    //reads in existing user data from nsuserdefaults
    func readInDataFromDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userName = defaults.stringForKey("userName"){
            if let userUniqueKey = defaults.stringForKey("userID"){
                var existingUser = User()
                existingUser.name = userName
                existingUser.uniqueID = userUniqueKey
                theUser = existingUser
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this is called when a pin is clicked, segues to the event view
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        if((view.annotation?.title)! != "Current Location"){
            popoverAnchor.frame = CGRectMake(view.frame.origin.x+10,
                view.frame.origin.y,
                view.frame.size.width,
                view.frame.size.height);
            performSegueWithIdentifier("eventPopover", sender: view)
        }
    }
    
    //Passes any objects the new view might need
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        if let newVC = destination as? EventViewController{
            
            //pass the appropriate event here
            if let theSender = sender?.annotation as? MapPin{
                newVC.event = theSender.event
                newVC.map   = map
                
                //give the view controller this MapViewController instance for event deletion
                newVC.mapInstance = self
            }
            if let ppc = newVC.popoverPresentationController {
                ppc.delegate = self
            }
            
        }else if let newVC = destination as? AddEventTableViewController{
            newVC.mapVC = self
        }
    }

    /*
        the next two functions that provide a back button on the popover view for iphones is taken from an answer on:
            http://stackoverflow.com/questions/25860781/how-to-use-dismiss-an-iphone-popover-in-an-adaptive-storyboard
    */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .FullScreen
    }
    func presentationController(controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?{
            
            let navController:UINavigationController = UINavigationController(rootViewController: controller.presentedViewController)
            controller.presentedViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action:"done")
            return navController
    }
    func done (){
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}

