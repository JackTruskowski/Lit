//
//  AddEventTableViewController.swift
//  Lit
//
//  Created by Jack Truskowski on 4/26/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var data: LitData?
    
    //storyboard vars
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var summaryField: UITextView!
    @IBOutlet weak var venuePicker: UIPickerView!
    
    @IBAction func addEventButtonPress(sender: UIButton) {
        
        //Check to ensure that the required fields are all filled in
        var errorMsg = ""
        if titleField.text == "" || titleField.text == nil {
            errorMsg = "The event must have a title"
        }else if summaryField.text == "" || summaryField.text == nil {
            errorMsg = "The event must have a description"
        }else if NSDate().compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg = "The end time of the event must be in the future"
        }else if startTimePicker.date.compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg = "The end time must be after the start time"
        }
        
        if errorMsg == ""{
            //add the event
            if(data?.currentUser != nil){
                let theVenue = Venue()
                theVenue.name = venueField.text! //TODO ask chris about this
                theVenue.location = mapVC!.mapView.userLocation.location //TODO turn an adress into location
                
                data?.addEvent((Event(eventTitle: titleField.text!, eventStartTime: startTimePicker.date, eventEndTime: endTimePicker.date, eventSummary: summaryField.text!, eventVenue: theVenue, eventHost: (data?.currentUser)!)))
                
            }else{
                print("no user exists")
            }
            
            //perform the segue
            performSegueWithIdentifier("addEvent", sender: sender);
        }else{
            let alertController = UIAlertController(title: "Error Adding Event", message: errorMsg,
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.venuePicker.delegate = self
        self.venuePicker.dataSource = self
        venuePicker.reloadAllComponents()
        
        //disable scrolling
        tableView.scrollEnabled = true
        
        //remove extraneous cells
        tableView.tableFooterView = UIView()
        
        //make dates in the past not options
        startTimePicker.minimumDate = NSDate()
        endTimePicker.minimumDate = NSDate()
    }
    
    // MARK: - functions for venuePicker/UIPickerView -> source: http://codewithchris.com/uipickerview-example/
    
    //the number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //the number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("Number of rows of data \(data?.venuesList.count)")
        return (data?.venuesList.count)!
    }
    
    //the data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(data?.venuesList)
        return (data?.venuesList[row].name)
    }
    
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    //adds the event to the list when the add event button is pressed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addVenue" {
            if let destination = segue.destinationViewController as? AddVenueViewController {
                destination.popoverPresentationController!.delegate = self
                destination.delegate = self //TODO does this need a delegate
            }
        }
    }
    
    //     venuePicker.reloadAllComponents() // TODO where to put this view did load?
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
