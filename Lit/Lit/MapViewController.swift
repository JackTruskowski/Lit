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
    
    
    //vars for testing only
    var anEvent = Event()
    var aHost = User()
    var aVenue = Venue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get permission to use location data
        mapView.showsUserLocation = true
        
        //make an event for testing
        aHost.name = "Jack Truskowski"
        aVenue.name = "Studzinski"
        anEvent.initWithParams("Jazz Concert", eventStartTime: nil, eventEndTime: nil, eventDescription: "A jazz concert", eventVenue: aVenue, eventHost: aHost)
        
    }
    
    @IBAction func zoomToLoc(sender: UIBarButtonItem) {
        panAndZoomToUserLocation()
    }
    
    @IBAction func refreshMapData(sender: UIBarButtonItem) {
        
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
            print(anEvent.title, anEvent.host?.name)
            newVC.event = anEvent
        }
    }


}

