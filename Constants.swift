//
//  Constants.swift
//  LocalFarming
//
//  Created by Chris Lu on 1/15/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import Foundation
import UIKit

struct ParseKeys {
    static let createdAtKey = "createdAt"
    
    static let CurrentProduceClassName = "AvailableProduce"
    static let ProduceNameKey = "produceName"
    static let ProduceFarmKey = "farm"
    static let ProducePriceKey = "price"
    static let ProduceUnitsKey = "units"
    static let ProducePurchasedStatusKey = "purchased"
    static let ProduceBidKey = "didBid"
    static let ProduceSourceObjectID = "produceID"
    
    static let FarmPhotoClassName = "FarmPhotos"
    static let FarmPhotoFarmKey = "farm"
    static let FarmPhotoImageKey = "image"
    
    static let UserOrderId = "orderID"
    static let UserOrderClassName = "userOrder"
    static let UserOrderUser = "user"
    static let UserOrderRelationKey = "purchased"
    static let UserOrderProduceClassName = "producePurchased"
    
    static let NotificationClassName = "notifications"
    static let NotificationDetails = "details"
    static let NotificationTitle = "title"
    static let NotificationProduceId = "produceId"
    static let NotificationProduceName = "produceName"
    static let NotificationOrderId = "orderId"
    static let NotificationUser = "user"
    static let NotificationTitleOutBid = "You have been outbid"
    
    static let PFObjectObjectID = "objectId"
}

struct Colors {
    static let lightGray = UIColor(red: 205/255, green: 205/255, blue: 193/255, alpha: 1.0)
    static let lightBrown = UIColor(red: 245/255, green: 222/255, blue: 179/255, alpha: 1.0)
    static let woodColor = UIColor(red: 205/255, green: 133/255, blue: 63/255, alpha: 1.0)
    static let headerFooterColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
    
}

