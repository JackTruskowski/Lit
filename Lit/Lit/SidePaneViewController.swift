//
//  SidePaneViewController.swift
//  Lit
//
//  Created by Simon Moushabeck on 4/25/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class SidePaneViewController: UIViewController {
    var currentUser: User?
    var data: Data?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = currentUser{
            userName.text = user.name
            if user.picture != nil{
                userPicture.image = user.picture
            }
        } else{
            userName.text = ""
            userPicture.image = UIImage(named: "useravatar")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
