//
//  UserModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class User: CustomStringConvertible{
    var name: String = ""
    var picture : UIImage?
    var passwordHash = 0
    var uniqueID = ""
    
    init(userName: String, ID: String){
        name = userName
        uniqueID = ID
    }
    
    var description: String{
        get{
            return name
        }
    }
}