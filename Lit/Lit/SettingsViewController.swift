//
//  SettingsViewController.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var data: LitData?
    var server = Server()
    
    //profile fields
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!

    
    @IBAction func save(sender: UIButton) {
        assignUser()
        navigationController?.popViewControllerAnimated(true)
    }
    
    //updates the global user variable if necessary
    func assignUser(){
        if data != nil {
            if profileName.text != nil {
                if let theUser = data!.currentUser {
                    theUser.name = profileName.text!
                    theUser.picture = profileImage.image
                    
                    server.postUserToServer(theUser)
                }else{
                    
                    let newID = random()
                    let theUser = User(userName: profileName.text!, id: newID)
                    

                
                    theUser.picture = profileImage.image
                    data!.currentUser = theUser
                    
                    //post this user to the server
                    server.postUserToServer(theUser)
                }
            }else{
                data!.currentUser = nil
            }
            // reload
        }
        // if data is nill, there's a problem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileName.delegate = self //TODO what is this for?
        
        //tap gesture recognizer for touching the picture
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        setupView()
    }
    
    func setupView(){
        //update profile picture
        if let theUser = data?.currentUser {
            profileImage.image = theUser.picture
            profileName.text = theUser.name
        }else{
            profileImage.image = UIImage(named: "useravatar")
        }
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
}
