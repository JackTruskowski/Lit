//
//  OptionsViewController.swift
//  Lit
//
//  Created by Simon Moushabeck on 5/5/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class OptionsViewController: UITableViewController {
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var radius: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime.minimumDate = NSDate().dateByAddingTimeInterval(-24 * 60 * 60)
        endTime.minimumDate = NSDate().dateByAddingTimeInterval(-24 * 60 * 60)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
