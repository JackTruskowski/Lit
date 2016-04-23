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
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapView.delegate = self
        
        //get permission to use location data
        mapView.showsUserLocation = true
    }
    
    //Actions triggered by the user
    @IBAction func zoomToLoc(sender: UIBarButtonItem) {
        panAndZoomToUserLocation()
    }
    
    //get updated event data for their location and populate map
    @IBAction func refreshMapData(sender: UIBarButtonItem) {
        
        //remove all old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        //add all the events to the map as annotations
        for var i = 0; i < addedEvents.count; ++i {
            let coordinates = CLLocationCoordinate2DMake((addedEvents[i].venue.location!.coordinate.latitude), (addedEvents[i].venue.location!.coordinate.longitude))
            let dropPin = MapPin(coordinate: coordinates, title: nil, subtitle: nil, event: addedEvents[i])
            mapView.addAnnotation(dropPin)
        }
    }
    
    //add an event to the map (pressing this button should also trigger a popover for adding event info)
    @IBAction func addEvent(sender: UIBarButtonItem) {
        
        //test event data
        //vars for testing only
        let aHost = User()
        let aVenue = Venue()
        
        
        //make a sample event for testing
        aHost.name = "Jack Truskowski"
        aVenue.name = "Studzinski"
        aVenue.location = mapView.userLocation.location
        let anEvent = Event(eventTitle: "Jazz Concert", eventStartTime: nil, eventEndTime: nil, eventDescription: "A jazz concert", eventVenue: aVenue, eventHost: aHost)
        addedEvents.append(anEvent)
        print(addedEvents.count)
        
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

