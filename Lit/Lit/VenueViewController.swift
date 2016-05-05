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
    var map : Map?

    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueCapacity: UILabel!
    @IBOutlet weak var venueManager: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBAction func addEvent(sender: UIButton) {
    }
    
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier = "
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if venue != nil {
            setupView()
        }
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        venueName.text = venue?.name
        venueAddress.text = venue?.address
        venueCapacity.text = "\((venue?.capacity)!)"
        venueManager.text = "\((venue?.manager)!)"
        
        //print("\(venue?.events[0])")
        
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
        print("\(map?.getVenueEventsCount(venue!))")
        return (map?.getVenueEventsCount(venue!))!
    }
    
    //populates the table with the events
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("anEventTableViewCell") as! EventTableViewCell
    
        print("populating table with events...")
        cell.eventTitleLabel.text = map?.getEventsAtVenue(venue!)![indexPath.row].title
 //           venue!.events[indexPath.row].title
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
