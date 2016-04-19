//
//  EventModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation

class Event{
    var title: String?
    var startTime: NSDate?
    var endTime: NSDate?
    var description: String?
    var venue: Venue?
    var host: User?
}