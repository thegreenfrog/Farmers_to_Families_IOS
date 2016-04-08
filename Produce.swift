//
//  Produce.swift
//  LocalFarming
//
//  Created by Chris Lu on 4/7/16.
//  Copyright © 2016 Bowdoin College. All rights reserved.
//

import Foundation

class Produce {
    let name: String!
    let farm: String!
    let price: Float!
    let quantity: Int!
    let id: String!
    let category: String!
    
    init(i: String, n: String, f: String, p: Float, q: Int, c: String) {
        id = i
        name = n
        farm = f
        price = p
        quantity = q
        category = c
    }
}