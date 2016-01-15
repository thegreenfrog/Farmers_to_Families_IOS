//
//  Constants.swift
//  LocalFarming
//
//  Created by Chris Lu on 1/15/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import Foundation

struct ParseKeys {
    static let CurrentProduceClassName = "AvailableProduce"
    static let ProduceNameKey = "produceName"
    static let ProduceFarmKey = "farm"
    static let ProduceNumKey = "produceCount"
    static let ProducePriceKey = "price"
    static let ProduceUnitsKey = "units"
    static let ProducePurchasedStatusKey = "purchased"
    
    static let FarmPhotoClassName = "FarmPhotos"
    static let FarmPhotoFarmKey = "farm"
    static let FarmPhotoImageKey = "image"
    
    static let UserOrderClassName = "userOrder"
    static let UserOrderUser = "user"
    static let UserOrderRelationKey = "purchased"
    static let UserOrderProduceClassName = "producePurchased"
    
    static let PFObjectObjectID = "objectId"
}
