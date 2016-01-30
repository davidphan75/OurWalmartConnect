//
//  OWCLocationManager.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation
import MapKit

class OWCLocationManager: CLLocationManager {
    static let sharedInstance = OWCLocationManager()
    var userLocation: CLLocation? {
        get {
            return askForAuthorization()
        }
    }
    
    override init() {
        super.init()
        
        askForAuthorization()
        
        desiredAccuracy = kCLLocationAccuracyBest
        startUpdatingLocation()
    }
    
    private func askForAuthorization() -> CLLocation? {
        if self.respondsToSelector("requestWhenInUseAuthorization") {
            if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() != .AuthorizedAlways {
                requestWhenInUseAuthorization()
            } else {
                return location
            }
        }
        
        return location
    }
}