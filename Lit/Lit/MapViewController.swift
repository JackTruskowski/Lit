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
var venuesTable : [Venue: [Event]] = [:] //dictionary where key is a Venue and value is a list of Events at that Venue

var theUser : User?

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    //this hidden view is needed to anchor the popover
    @IBOutlet weak var popoverAnchor: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    

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

