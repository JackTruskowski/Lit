//
//  EventViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var event : Event?

    //storyboard vars
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventHost: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event != nil{
            setupView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        eventTitle.text = event?.title
        eventHost.text = event?.host?.name
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
