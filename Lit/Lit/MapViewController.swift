//
//  MapViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    //this hidden view is needed to anchor the popover
    @IBOutlet weak var popoverAnchor: UIView!
    
    //Todo: better way to store this, maybe hashing of some sort by location
    var addedEvents : [Event] = []
    var theUser : User?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapView.delegate = self
        
        //get permission to use location data
        mapView.showsUserLocation = true
        
        //make a sample event from a different user for testing
        let aVenue = Venue()
        let aHost = User()
        aHost.name = "Guy Chill"
        aHost.uniqueID = 2000
        
        //make a sample event for testing
        //aHost.name = "Jack Truskowski"
        aVenue.name = "Smith Union"
        let aLocation = CLLocation(latitude: 37.781536, longitude: -122.426327)
        aVenue.location = aLocation
        let anEvent = Event(eventTitle: "Club Fair", eventStartTime: nil, eventEndTime: nil, eventDescription: "A fair with clubs", eventVenue: aVenue, eventHost: aHost)
        
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
        
        addedEvents.append(anEvent)
        
        
        
        
        
        
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
        if(theUser != nil){
            //test event data
            //vars for testing only
            //let aHost = User()
            let aVenue = Venue()
        
            //make a sample event for testing
            //aHost.name = "Jack Truskowski"
            aVenue.name = "Studzinski"
            aVenue.location = mapView.userLocation.location
            let anEvent = Event(eventTitle: "Jazz Concert", eventStartTime: nil, eventEndTime: nil, eventDescription: "A jazz concert", eventVenue: aVenue, eventHost: theUser!)
            
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
            
            anEvent.addAttendee(theUser!)
            anEvent.addAttendee(user1)
            anEvent.addAttendee(user2)
            anEvent.addAttendee(user3)
            anEvent.addAttendee(user4)
            anEvent.updateAttendance(5)
            
            addedEvents.append(anEvent)
        }else{
            
            //give an alert saying the user must be signed in
            let alertController = UIAlertController(title: "Error", message:
                "You must be signed in to add an event", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func initializeUser(aUser : User){
        theUser = aUser
    }
    
    func refreshAnnotations(){
        
        //remove all old annotations
        mapView.removeAnnotations(mapView.annotations)
        
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
                //give the view controller this MapViewController instance for event deletion
                newVC.mapInstance = self
            }
            if let ppc = newVC.popoverPresentationController {
                ppc.delegate = self
            }
            
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

