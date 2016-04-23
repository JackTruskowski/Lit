//
//  MapViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    //Todo: better way to store this, maybe hashing of some sort 
    var addedEvents : [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = CLLocationCoordinate2DMake((addedEvents[i].venue?.location!.coordinate.latitude)!, (addedEvents[i].venue?.location!.coordinate.longitude)!)
            dropPin.title = addedEvents[i].title
            mapView.addAnnotation(dropPin)
        }
    }
    
    //add an event to the map (pressing this button should also trigger a popover for adding event info)
    @IBAction func addEvent(sender: UIBarButtonItem) {
        
        //test event data
        //vars for testing only
        let anEvent = Event()
        let aHost = User()
        let aVenue = Venue()
        
        
        //make an event for testing
        aHost.name = "Jack Truskowski"
        aVenue.name = "Studzinski"
        aVenue.location = mapView.userLocation.location
        anEvent.initWithParams("Jazz Concert", eventStartTime: nil, eventEndTime: nil, eventDescription: "A jazz concert", eventVenue: aVenue, eventHost: aHost)
        addedEvents.append(anEvent)
        print(addedEvents.count)
        
    }
    
    
    func panAndZoomToUserLocation(){
        
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        if let newVC = destination as? EventViewController{
            //pass the appropriate event here
            newVC.event = addedEvents[0]
        }
    }


}

