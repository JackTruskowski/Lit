//
//  VenueModel.swift
//  Lit
//
//  Created by Simon J. Moushabeck on 4/19/16.
//  Copyright © 2016 Jack Chris and Simon. All rights reserved.
//

import Foundation
import MapKit

class Venue {
    var name: String = ""
    var address: String = ""
    var summary: String?
    var location: CLLocation?
    var events : [Event] = []
    
    //functions
    init(venueName: String, venueAddress: String) {
        name = venueName
        address = venueAddress
        
        //convert address to a location with longitude and latitude: http://mhorga.org/2015/08/14/geocoding-in-ios.html
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(venueAddress, completionHandler: {(placemarks, error) in
            if error != nil {
                print("Error: ", error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                self.location = placemark?.location
                let coordinate = self.location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
            }else{
                print("no locations found")
            }
        })
    }
    
    init() {
        name = "New Venue"
        address = "New Address"
    }
}