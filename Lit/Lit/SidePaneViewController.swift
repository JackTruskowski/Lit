//
//  SidePaneViewController.swift
//  Lit
//
//  Created by Simon Moushabeck on 4/25/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class SidePaneViewController: UIViewController {
    var data: LitData?
    var userID: Int? // we will randomly generate this on user creation
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = data?.currentUser{
            userName.text = user.name
            if user.picture != nil{
                profilePicture.image = user.picture
            }
        } else{
            userName.text = ""
            profilePicture.image = UIImage(named: "useravatar")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

