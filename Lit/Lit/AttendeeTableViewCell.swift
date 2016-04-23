//
//  AttendeeTableViewCell.swift
//  Lit
//
//  Created by Jack Truskowski on 4/23/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class AttendeeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
