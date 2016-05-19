//
//  VenueViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var venue: Venue?
    var data: LitData?

    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var addEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    func setupView() {
        if(venue == nil) {
            return
        }
        let theVenue = venue!
        
        venueName.text = theVenue.name
        venueAddress.text = theVenue.address
        
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
    
    override func viewWillAppear(animated: Bool) {
        eventsTableView.reloadData()
        if data?.currentUser == nil{
            addEventButton.setTitle("Sign In to add events", forState: UIControlState.Normal)
            addEventButton.enabled = false
            addEventButton.alpha = 0.5
        } else {
            addEventButton.setTitle("Schedule an Event", forState: UIControlState.Normal)
            addEventButton.enabled = true
            addEventButton.alpha = 1
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addEventFromVenue" {
            let destination = segue.destinationViewController as! UINavigationController
            let newVC = destination.topViewController as! AddEventViewController
            
            newVC.selectedVenue = venue
            newVC.data = data
            
        }
    }
}
