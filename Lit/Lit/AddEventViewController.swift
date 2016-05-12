//
//  AddEventViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 5/9/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var data: LitData?
    let server = Server()
    
    //storyboard vars
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var summaryField: UITextView!
    @IBOutlet weak var venuePicker: UIPickerView!
    
    var selectedVenue: Venue?
    
    @IBAction func addEvent(sender: UIButton) {
        
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
                
                let newEvent = Event(eventTitle: titleField.text!, eventStartTime: startTimePicker.date, eventEndTime: endTimePicker.date, eventSummary: summaryField.text!, eventVenue: selectedVenue!, eventHost: (data?.currentUser)!)
        
                data?.addEvent(newEvent)
                selectedVenue?.events.append(newEvent)
                server.postEventToServer(newEvent)
                
            }else{
                print("no user exists")
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "Error Adding Event", message: errorMsg,
                preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.venuePicker.delegate = self
        self.venuePicker.dataSource = self
        
        //make dates in the past not options
        startTimePicker.minimumDate = NSDate()
        endTimePicker.minimumDate = NSDate()
        
        //find the venue in the venue list
        if selectedVenue != nil{
            venuePicker.selectRow((data?.venuesList.indexOf({$0 === selectedVenue!})) ?? 0, inComponent: 0, animated: true)
            venuePicker.userInteractionEnabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View will appear")
        venuePicker.reloadAllComponents()
        if data?.venuesList.isEmpty == false {
            venuePicker.selectRow(0, inComponent: 0, animated: true)
        }
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
            if let destination = segue.destinationViewController as? UINavigationController {
                if let newVC = destination.topViewController as? AddVenueViewController {
                    newVC.data = data
                }
            }
        }
    }
}
