//
//  OptionsViewController.swift
//  Lit
//
//  Created by Simon Moushabeck on 5/5/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class OptionsViewController: UITableViewController {
    var data: LitData?
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var radius: UISlider!
    @IBOutlet weak var addVenueButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime.minimumDate = NSDate().dateByAddingTimeInterval(-24 * 60 * 60)
        endTime.minimumDate = NSDate().dateByAddingTimeInterval(-24 * 60 * 60)
    }
    
    override func viewWillAppear(animated: Bool) {
        if data?.currentUser == nil {
            addEventButton.setTitle("Sign In to add events", forState: UIControlState.Normal)
            addEventButton.enabled = false
            addVenueButton.setTitle("Sign In to add venues", forState: UIControlState.Normal)
            addVenueButton.enabled = false
        } else {
            addEventButton.setTitle("Add Event", forState: UIControlState.Normal)
            addEventButton.enabled = true
            addVenueButton.setTitle("Add Venue", forState: UIControlState.Normal)
            addVenueButton.enabled = true
        }
    }
    
    @IBAction func changeStartTime(sender: UIDatePicker) {
    }
    
    @IBAction func changeEndTime(sender: UIDatePicker) {
    }
    
    @IBAction func changeRadius(sender: UISlider) {
    }
    
    @IBAction func changeAutoCheckIn(sender: UISwitch) {
    }
    
    @IBAction func logout() {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToAddEvent" {
            if let destination = segue.destinationViewController as? UINavigationController{
                if let newVC = destination.topViewController as? AddEventViewController{
                    newVC.data = data
                }
            }
        }else if segue.identifier == "segueToAddVenue" {
            if let destination = segue.destinationViewController as? UINavigationController{
                if let newVC = destination.topViewController as? AddVenueViewController{
                    newVC.data = data
                }
            }
        }
    }
}
