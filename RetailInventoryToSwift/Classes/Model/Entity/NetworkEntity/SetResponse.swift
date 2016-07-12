//
//  SetResponse.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/11/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct SetResponse {
    var active: Bool?
    var id: Int?
    var manyPer: Bool?
    var max: Bool?
    var name: String?
    var applyPriceTo: Bool?
    var loactionId: Int?
    var oneOnly: Bool?
    var onePer: Bool?
    var prependSetName: Bool?
    var required: Bool?
    var setPrice: Bool?
    
    init(withDictionary repsonse: [String:AnyObject]) {
        active = repsonse["active"] as? Bool
        id = repsonse["id"] as? Int
        manyPer = repsonse["manyPer"] as? Bool
        max = repsonse["max"] as? Bool
        name = repsonse["name"] as? String
        applyPriceTo = repsonse["applyPriceTo"] as? Bool
        loactionId = repsonse["loactionId"] as? Int
        oneOnly = repsonse["oneOnly"] as? Bool
        onePer = repsonse["onePer"] as? Bool
        prependSetName = repsonse["prependSetName"] as? Bool
        required = repsonse["required"] as? Bool
        setPrice = repsonse["setPrice"] as? Bool
    }
}