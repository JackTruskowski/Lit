//
//  VenueViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var venue : Venue?

    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueManager: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if venue != nil {
            setupView()
        }
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        venueName.text = venue?.name
        venueAddress.text = venue?.address
        venueManager.text = "\((venue?.manager)!)"
        
        print("\(venue?.events[0])")
        
        //TODO what is this?
        //user must be signed in to schedule event
        /*if userIsSignedIn {
            deleteEventButton.hidden = true
        }else{
            deleteEventButton.hidden = false
        }*/
        
    }
    
    //returns the number of rows that the events table will have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in tableView function in Venue VC")
        return (venue?.events.count)!
    }
    
    //populates the table with the events
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("anEventTableViewCell") as! EventTableViewCell
    
        print("populating table with events...")
        cell.eventTitleLabel.text = venue!.events[indexPath.row].title
        return cell
    }
    
    // TODO add event scheduling from venue (ommitted for now for simplicity)
}
