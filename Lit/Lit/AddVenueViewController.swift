//
//  AddVenueViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 5/9/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class AddVenueViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var summary: UITextView!
    
    var data: LitData?
    var server = Server()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addVenue() {
        // check them to make sure they are not nil
        print("hello")
        if data == nil {
            print("Data is nil")
        }
        let aNewVenue = Venue(venueName: name.text!, venueAddress: address.text!)
        aNewVenue.summary = summary.text!
        
        print(aNewVenue.location)
        
        data?.addVenue(aNewVenue)
        server.postVenueToServer(aNewVenue)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
