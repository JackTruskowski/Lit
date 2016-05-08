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
        
        if event != nil{
            setupView()
        } else{
            //TODO something
        }
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
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
    
    //called when the view loads to populate all the event fields in the view and hide the delete button
    func setupView(){
        
        //setup summary
        summaryView.text = event?.summary
        summaryView.scrollEnabled = false
        
        //make the summary field an appropriate size
        let fixedWidth = summaryView.frame.size.width
        summaryView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = summaryView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = summaryView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        summaryView.frame = newFrame;
        
        eventTitle.text = event?.title
        eventHost.text = event?.venue.name
        eventVenue.text = event?.host.name
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MM-dd HH:mm"
    
        startTime.text = dateFormatter.stringFromDate((event?.startTime)!)
        endTime.text = dateFormatter.stringFromDate((event?.endTime)!)
        
        //do button-related setup
        if theUser?.uniqueID != event?.host.uniqueID {
            deleteEventButton.hidden = true
        }else{
            deleteEventButton.hidden = false
        }
        
        let isUserThere = event?.userIsAttending(theUser)
        if isUserThere == true {
            checkInButton.setTitle("Leave Event", forState: UIControlState.Normal)
            checkedIn = true
        }else{
            checkInButton.setTitle("Check-In", forState: UIControlState.Normal)
            checkedIn = false
        }
        
        
    }
    
    //returns the number of rows that the attendee table will have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event?.attendees.count)!
    }
    
    //action that deletes the current event, removes it from the map, and dismisses the popover view
    @IBAction func deleteEventPressed(sender: UIButton) {
        
        if mapInstance != nil && event != nil{
            mapInstance?.deleteEvent(event!)
            mapInstance?.refreshAnnotations()
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
                }
                if let ppc = newVC.popoverPresentationController {
                    print("self is a delegate")
                    ppc.delegate = self
                }
            }
        }
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
