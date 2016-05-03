//
//  AddEventTableViewController.swift
//  Lit
//
//  Created by Jack Truskowski on 4/26/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController {
    
    var mapVC : MapViewController?
    
    //storyboard vars
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var venueField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!

    @IBAction func addEventButtonPress(sender: UIButton) {
        
        //Check to ensure that the required fields are all filled in
        var errorMsg = ""
        
        if titleField.text == "" || titleField.text == nil {
            errorMsg = "The event must have a title"
        }else if venueField.text == "" || venueField.text == nil {
            errorMsg = "The event must have a venue"
        }else if descriptionField.text == "" || descriptionField.text == nil {
            errorMsg = "The event must have a description"
        }else if NSDate().compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg = "The end time of the event must be in the future"
        }
        
        if errorMsg == ""{
            //perform the segue
            performSegueWithIdentifier("addEvent", sender: sender);
        }else{
            let alertController = UIAlertController(title: "Error Adding Event", message:
                errorMsg, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //disable scrolling
        tableView.scrollEnabled = false
        
        //remove extraneous cells
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //adds the event to the list when the add event button is pressed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addEvent" {
            let destination = segue.destinationViewController
            if let _ = destination as? MapViewController{
                if(theUser != nil){
                 
                        //add the event here
                        let theVenue = Venue()
                        theVenue.name = venueField.text!
                        theVenue.location = mapVC!.mapView.userLocation.location
                
                        addedEvents.append(Event(eventTitle: titleField.text!, eventStartTime: startTimePicker.date, eventEndTime: endTimePicker.date, eventDescription: "test", eventVenue: theVenue, eventHost: theUser!))
                    
                }else{
                    print("no user exists")
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
