//
//  DateAndTimeTableViewCell.swift
//  Lit
//
//  Created by Simon Moushabeck on 4/25/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import UIKit

class DateAndTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var DateAndTime: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
