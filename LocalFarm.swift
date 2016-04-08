//
//  LocalFarm.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/14/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import Foundation
import MapKit
import Parse

class LocalFarm: NSObject {
    let title: String?
    let locationName: String
    let produceList: [PFObject]
    
    init(title: String, locationName: String, produce: [PFObject]) {
        self.title = title
        self.locationName = locationName
        self.produceList = produce
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
