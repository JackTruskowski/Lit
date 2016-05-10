//
//  MapViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

//TODO consider making arrays dictionarys for quick lookups and removals
//   only problem is then names become keys, so venues and events can't have duplicate names

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate{
    // this is the only time we create a LitData object, everyone else has references to this one
    var data: LitData = LitData()
    let serverInstance = Server()
    
    @IBOutlet var mapView: MKMapView!

    //this hidden view is needed to anchor the popover
    @IBOutlet weak var popoverAnchor: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapView.delegate = self
        
        //get permission to use location data
        mapView.showsUserLocation = true
        
        //read in user defaults
        readInDataFromDefaults()
        
        serverInstance.mapData = data
        
        //read in existing events from server
        serverInstance.refreshEventsFromServer()
        
        //refresh right when the view loads
        refreshAnnotations()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshAnnotations()
    }
    
    //reads in existing user data from nsuserdefaults
    func readInDataFromDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userName = defaults.stringForKey("userName"){
            let userUniqueKey = defaults.integerForKey("userID")
            let existingUser = User(userName: userName, ID: userUniqueKey)
            data.currentUser = existingUser
        }
    }
    
    func refreshAnnotations(){
        //remove all old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        serverInstance.refreshEventsFromServer()
        
        print(data.eventsList.count)
        
        //add all the events to the map as annotations
        for i in 0 ..< data.eventsList.count {
            print(data.eventsList[i].venue)
            let coordinates = CLLocationCoordinate2DMake((data.eventsList[i].venue.location!.coordinate.latitude), (data.eventsList[i].venue.location!.coordinate.longitude))
            let dropPin = MapPin(coordinate: coordinates, title: nil, subtitle: nil, event: data.eventsList[i])
            mapView.addAnnotation(dropPin)
        }
    }
    
    //
    //Actions triggered by the user
    //
    
    @IBAction func zoomToLoc(sender: UIBarButtonItem) {
        panAndZoomToUserLocation()
    }
    
    //get updated event data for their location and populate map
    @IBAction func refreshMapData(sender: UIBarButtonItem) {
        refreshAnnotations()
    }
    
    //removes an event from the array
    func deleteEvent(anEvent: Event){
        for i in 0 ..< data.eventsList.count{
            if data.eventsList[i] === anEvent {
                data.eventsList.removeAtIndex(i)
            }
        }
    }
    
    //TODO: It would be nice to do this immediately, but that causes a crash - the user must click the zoom button for now // VIEW DID APPEAR
    func panAndZoomToUserLocation(){
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
    
    
    //this is called when a pin is clicked, segues to the event view
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        if((view.annotation?.title)! != "Current Location"){
            popoverAnchor.frame = CGRectMake(view.frame.origin.x+10,
                view.frame.origin.y,
                view.frame.size.width,
                view.frame.size.height);
            performSegueWithIdentifier("segueToEventPopover", sender: view) //TODO Does this actually make a popover segue?
        }
    }
    
    //Passes any objects the new view might need
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToEventPopover" {
            let destination = segue.destinationViewController as! UINavigationController
            let newVC = destination.topViewController as! EventViewController
            
            if let theSender = sender?.annotation as? MapPin{
                newVC.event = theSender.event
                newVC.data = data
            }
            
            if let ppc = newVC.popoverPresentationController { //TODO what is this?
                ppc.delegate = self
            }
        } else if segue.identifier == "showOptions" {
            if let destination = segue.destinationViewController as? UINavigationController{
                if let newVC = destination.topViewController as? SidePaneViewController{
                    newVC.data = data
                }
            }
        }
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        print("hitting back button")

        if let destination = parent as? SidePaneViewController{
            print("got destination")
                destination.data = data
        }
    }

    
    //TODO style the popover so that we don't need a back button, instead it looks like a bubble, and clicking outside closes it
    // also we may need to move the view so that the pin is at the bottom center.
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

