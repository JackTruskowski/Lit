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
    var picture: UIImage?
    var ID: Int = 0
    
    init(userName: String, id: Int){
        name = userName
        ID = id
    }
    
    var description: String{
        get{
            return name
        }
    }
}
