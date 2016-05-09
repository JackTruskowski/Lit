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
    
    var selectedVenue:Venue?
    
    @IBAction func addEventButtonPress(sender: UIButton) {
        
        //Check to ensure that the required fields are all filled in
        var errorMsg = ""
        if titleField.text == "" || titleField.text == nil {
            errorMsg += "The event must have a title\n"
        }else if summaryField.text == "" || summaryField.text == nil {
            errorMsg += "The event must have a description\n"
        }else if selectedVenue == nil{
            errorMsg += "Please select a venue from the list\n"
        }else if NSDate().compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg += "The end time of the event must be in the future\n"
        }else if startTimePicker.date.compare(endTimePicker.date) == NSComparisonResult.OrderedDescending{
            errorMsg += "The end time must be after the start time\n"
        }
        
        if errorMsg == ""{
            //add the event
            if(data?.currentUser != nil){ //TODO we should make sure we have a user before segueing to here
                
                data?.addEvent((Event(eventTitle: titleField.text!, eventStartTime: startTimePicker.date, eventEndTime: endTimePicker.date, eventSummary: summaryField.text!, eventVenue: selectedVenue!, eventHost: (data?.currentUser)!)))
                
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
        
        
        //disable scrolling
        tableView.scrollEnabled = true
        
        //remove extraneous cells
        tableView.tableFooterView = UIView()
        
        //make dates in the past not options
        startTimePicker.minimumDate = NSDate()
        endTimePicker.minimumDate = NSDate()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View will appear")
        venuePicker.reloadAllComponents()
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
        if data?.venuesList.count == 0{
            selectedVenue = nil
        } else{
            selectedVenue = data?.venuesList[row]
        }
        
        
    }
    
    //adds the event to the list when the add event button is pressed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addVenue" {
            if let destination = segue.destinationViewController as? AddVenueViewController {
                destination.popoverPresentationController!.delegate = self
                destination.data = data
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
