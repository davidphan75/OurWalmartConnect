//
//  OWCWalmartLocation.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

import Foundation
import MapKit

class OWCWalmartLocation: NSObject, MKAnnotation {
    var name = ""
    var address = ""
    var location: CLLocation
    var parseObject: PFObject?
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    var state:String?
    var city:String?
    
    private override init() {
        location = CLLocation(latitude: 0, longitude: 0)
        coordinate = location.coordinate
    }
    
    convenience init(name: String, address: String, location: CLLocation) {
        self.init()
        
        self.name = name
        self.address = address
        self.location = location
        
        self.title = name
        self.subtitle = address
        self.coordinate = location.coordinate
    }
    
    convenience init(city:String,address: String,state:String, location: CLLocation) {
        self.init()
        
        //self.name = name
        self.city = city
        self.state = state
        
        self.address = address
        self.location = location
        
        self.title = city
        self.subtitle = address
        self.coordinate = location.coordinate
    }
    
    
    convenience init(object: PFObject) {
        let geopoint = object.objectForKey("location") as! PFGeoPoint
        self.init(name: object.objectForKey("name") as! String, address: "Unavailable", location: CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        parseObject = object
    }
}