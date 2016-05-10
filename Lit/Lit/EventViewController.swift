//
//  EventViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var event: Event?
    var data: LitData?
    var checkedIn = false
    
    //storyboard vars
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventHost: UILabel!
    @IBOutlet weak var eventVenue: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var deleteEventButton: UIButton!
    @IBOutlet weak var attendanceCount: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var summaryView: UITextView!
    @IBOutlet weak var checkInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        
        eventTableView.dataSource = self
        eventTableView.delegate = self
    }
    
    //called when the view loads to populate all the event fields in the view and hide the delete button
    func setupView(){
        if event == nil{
            print("cannot setup nil event")
            return
        }
        let theEvent = event!
        
        //setup summary
        summaryView.text = theEvent.summary
        summaryView.scrollEnabled = false
        
        //make the summary field an appropriate size
        let fixedWidth = summaryView.frame.size.width
        let newSize = summaryView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = summaryView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        summaryView.frame = newFrame;
        
        eventTitle.text = theEvent.title
        eventVenue.text = theEvent.venue.name
        eventHost.text = theEvent.host.name
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        
        startTime.text = dateFormatter.stringFromDate(theEvent.startTime)
        endTime.text = dateFormatter.stringFromDate(theEvent.endTime)
        
        //do button-related setup
        if let theUser = data?.currentUser{ // confirm that there is a user
            
            // is the user in attendance
            let isUserThere = theEvent.userIsAttending(theUser)
            if isUserThere {
                checkInButton.setTitle("Leave Event", forState: UIControlState.Normal)
                checkedIn = true
            }else{
                checkInButton.setTitle("Check-In", forState: UIControlState.Normal)
                checkedIn = false
            }
            
            // can the user delete events
            if theUser.uniqueID != theEvent.host.uniqueID {
                deleteEventButton.hidden = true
            }else{ deleteEventButton.hidden = false }

        } else{ // if there is no user, they can't check in, or delete events
            checkInButton.hidden = true
            deleteEventButton.hidden = true
        }
    }
    
    
    @IBAction func checkInButtonPressed(sender: UIButton) {
        if checkedIn == false{
            event?.addAttendee((data?.currentUser)!)
            checkedIn = true
        }else{
            event?.removeAttendee((data?.currentUser)!)
            checkedIn = false
        }
        setupView()
        eventTableView.reloadData()
    }
    
    @IBAction func backToMap(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //returns the number of rows that the attendee table will have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event?.attendees.count)!
    }
    
    //action that deletes the current event, removes it from the map, and dismisses the popover view
    @IBAction func deleteEventPressed(sender: UIButton) {
        if data != nil && event != nil{
            data?.deleteEvent(event!)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //populates the table with the attendees and their images
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("aTableViewCell") as! AttendeeTableViewCell
        
        if event?.attendees[indexPath.row].picture != nil{
            cell.userImage.image = event?.attendees[indexPath.row].picture
        }else{
            cell.userImage.image = UIImage(named: "useravatar")
        }
        cell.nameLabel.text = event?.attendees[indexPath.row].name
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "venueDetail" {
            let destination = segue.destinationViewController
            if let newVC = destination as? VenueViewController{
                //pass the appropriate venue here
                if let theVenue = event?.venue {
                    newVC.venue = theVenue
                    newVC.data  = data
                }
            }
        }
    }
}
