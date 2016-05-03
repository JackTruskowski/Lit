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
        //perform the segue
        performSegueWithIdentifier("addEvent", sender: sender);
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
                    if(titleField.text != "" && titleField.text != nil && venueField.text != "" && venueField.text != nil && descriptionField.text != "" && descriptionField.text != nil){
                        //add the event here
                        let theVenue = Venue()
                        theVenue.name = venueField.text!
                        theVenue.location = mapVC!.mapView.userLocation.location
                
                        addedEvents.append(Event(eventTitle: titleField.text!, eventStartTime: nil, eventEndTime: nil, eventDescription: "test", eventVenue: theVenue, eventHost: theUser!))
                    }
                    else{
                        print("one of the fields doesn't exist")
                    }
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
