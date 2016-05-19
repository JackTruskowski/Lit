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
        let aNewVenue = Venue(venueName: name.text!, venueAddress: address.text!, venueID: random())
        aNewVenue.summary = summary.text!
        
        print(aNewVenue.address)
        
        data?.addVenue(aNewVenue)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
