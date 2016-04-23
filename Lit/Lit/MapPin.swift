//
//  MapPin.swift
//  Lit
//
//  Created by Jack Truskowski on 4/23/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

/*
    This class is a custom pin object that allows us to associate an event with the pin
*/


import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var event: Event
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, event: Event) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.event = event
    }
}