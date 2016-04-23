//
//  EventViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var event : Event?

    //storyboard vars
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventHost: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var attendanceCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event != nil{
            setupView()
        }
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        eventTitle.text = event?.title
        eventHost.text = event?.venue.name
        attendanceCount.text = "\((event?.attendanceCount)!)"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(event?.attendees.count)
        return (event?.attendees.count)!
    }
    
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
    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("WebSegue", sender: indexPath)
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
