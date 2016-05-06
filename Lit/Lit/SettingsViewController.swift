//
//  SettingsViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var myProfile : User?
    
    //profile fields
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var userID: UITextField!
    
    @IBOutlet weak var backToMapButton: UIButton!

    
    @IBAction func `return`(sender: UIButton) {
        
        //dont perform segue if its an ipad
        let deviceIdiom = UIScreen.mainScreen().traitCollection.userInterfaceIdiom
        if deviceIdiom == .Phone{
            performSegueWithIdentifier("returnToMap", sender: nil)
        }else{
            if let split = self.splitViewController {
                let controllers = split.viewControllers
                if let _ = controllers[1] as? MapViewController {
                    assignUser()
                }
                
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        if let _ = destination as? MapViewController{
            assignUser()
        }
        
    }
    
    //updates the global user variable if necessary
    func assignUser(){
        if profileName.text != ""{
            if myProfile != nil{
                myProfile!.name = profileName.text
                myProfile!.picture = profileImage.image
            }else{
                myProfile = User()
                if userID.text != ""{
                    myProfile!.uniqueID = userID.text!
                }else{
                    myProfile!.uniqueID = "ad24rew"
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(myProfile!.uniqueID, forKey: "userID")
                
                myProfile!.name = profileName.text
                myProfile!.picture = profileImage.image
            }
            theUser = myProfile!
        }else{
            theUser = nil
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileName.delegate = self
        
        //tap gesture recognizer for touching the picture
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(SettingsViewController.imageTapped(_:)))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        //update profile picture
        if myProfile?.picture != nil {
            profileImage.image = myProfile!.picture
        }else{
            profileImage.image = UIImage(named: "useravatar")
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        //fill in the name field if user defaults exist
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userName = defaults.stringForKey("userName"){
            profileName.text = userName
        }
        if let id = defaults.stringForKey("userID"){
            userID.text = id
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(image: AnyObject){
        //allow user to select an image
        selectPicture()
    }
    
    /*
        Image selection code from:
            https://www.hackingwithswift.com/example-code/media/how-to-choose-a-photo-from-the-camera-roll-using-uiimagepickercontroller
    */
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        profileImage.image = newImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //hides the keyboard when the user hits the return button
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
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
