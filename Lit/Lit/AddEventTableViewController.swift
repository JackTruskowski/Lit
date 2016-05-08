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
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var venuePicker: UIPickerView!
    
    
    
    @IBAction func createVenue(sender: AnyObject) {
    }
    
    @IBAction func addEventButtonPress(sender: UIButton) {
        
        //Check to ensure that the required fields are all filled in
        var errorMsg = ""
        
        //TODO fix these checks
        if titleField.text == "" || titleField.text == nil {
            errorMsg = "The event must have a title"
        //}else if venueField.text == "" || venueField.text == nil {
        //    errorMsg = "The event must have a venue"
        }else if descriptionField.text == "" || descriptionField.text == nil {
            errorMsg = "The event must have a description"
        }else if NSDate().compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg = "The end time of the event must be in the future"
        }else if startTimePicker.date.compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg = "The end time must be after the start time"
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
        
        self.venuePicker.delegate = self
        self.venuePicker.dataSource = self
        
        //disable scrolling
        tableView.scrollEnabled = true
        
        
        //remove extraneous cells
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK -- functions for venuePicker/UIPickerView -> source: http://codewithchris.com/uipickerview-example/
    
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
        if segue.identifier == "addEvent" {
            let destination = segue.destinationViewController
            if let _ = destination as? MapViewController{
                if(theUser != nil){
                    
                    //add the event here
                    let theVenue = Venue()
                    theVenue.name = venueField.text!
                    theVenue.location = mapVC!.mapView.userLocation.location
                    
                    addedEvents.append(Event(eventTitle: titleField.text!, eventStartTime: startTimePicker.date, eventEndTime: endTimePicker.date, eventDescription: descriptionField.text!, eventVenue: theVenue, eventHost: theUser!))
                    
                }else{
                    print("no user exists")
                }
            }
        } else if segue.identifier == "addVenue" {
            let destination = segue.destinationViewController
            if let newVC = destination as? AddVenueViewController {
                newVC.popoverPresentationController!.delegate = self
                newVC.delegate = self
                newVC.map = mapVC!.map
                
            }
        }
    }
    
    //     venuePicker.reloadAllComponents() // TODO where to put this
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
