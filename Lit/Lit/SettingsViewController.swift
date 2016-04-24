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
    var mapVC : MapViewController?
    
    //profile fields
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    
    @IBAction func updateProfile(sender: UIButton) {
        
        if myProfile != nil{
            myProfile!.name = profileName.text
            myProfile!.picture = profileImage.image
        }else{
            myProfile = User()
            myProfile!.uniqueID = 101
            myProfile!.name = profileName.text
            myProfile!.picture = profileImage.image
        }
        mapVC?.theUser = myProfile
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileName.delegate = self

        //tap gesture recognizer for touching the picture
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        //update profile picture
        if myProfile?.picture != nil {
            profileImage.image = myProfile!.picture
        }else{
            profileImage.image = UIImage(named: "useravatar")
        }
        
        //add the detail
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            if let newVC = controllers[1] as? MapViewController{
                mapVC = newVC
            }
            
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
        
        mapVC?.theUser = myProfile
        
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
