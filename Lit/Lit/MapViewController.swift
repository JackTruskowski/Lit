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
    
    var anEvent = Event()
    var aHost = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //make an event for testing
        aHost.name = "Jack Truskowski"
        anEvent.initWithParams("Jazz Concert", eventStartTime: nil, eventEndTime: nil, eventDescription: "A jazz concert", eventVenue: nil, eventHost: aHost)
        
        
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

