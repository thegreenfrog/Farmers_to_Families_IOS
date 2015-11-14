//
//  LocalFarm.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/14/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import Foundation
import MapKit

class LocalFarm: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
