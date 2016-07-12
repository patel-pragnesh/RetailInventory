//
//  TagResponse.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/11/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct TagResponse {
    var active: Bool?
    var hidden: Bool?
    var id: Int?
    var itemTagDesc: String?
    var locationId: Int?
    var ordinalNum: Int?
    var sortMode: Bool?
    
    init(withDictionary response: [String:AnyObject]) {
        active = response["active"] as? Bool
        hidden = response["hidden"] as? Bool
        id = response["id"] as? Int
        itemTagDesc = response["itemTagDesc"] as? String
        locationId = response["locationId"] as? Int
        ordinalNum = response["ordinalNum"] as? Int
        sortMode = response["sortMode"] as? Bool
    }
}