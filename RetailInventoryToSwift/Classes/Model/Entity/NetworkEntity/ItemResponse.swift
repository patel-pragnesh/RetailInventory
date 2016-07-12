//
//  ItemResponse.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/8/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct ItemResponse {
    var departmentId: Int?
    var itemName: String?
    var itemNotes: String?
    var price: String?
    var cost: String?
    var id: Int?
    var lookup: String?
    var printItem: Bool?
    var openItem: Bool?
    var usesWeightScale: Bool?
    var weighted: Bool?
    var tareWeight: Int?
    var itemShortName: String?
    var qtyOnHand: Int?
    var icon: String?
    var color: String?
    var active: Bool?
    
    var isGift: Bool?
    var inheritTaxes: Bool?
    var locationId: Int?
    var itemTags: String?
    var minQty: Int?
    var unit: String?
    var deptOpenKey: Bool?
    var ebtItem: Bool?
    
    init(withDictionary reponse: [String:AnyObject]) {
        departmentId = reponse["departmentId"] as? Int
        itemName = reponse["itemName"] as? String
        itemNotes = reponse["itemNotes"] as? String
        price = String((reponse["price"] as? Int)!)
        cost = String((reponse["cost"] as? Int)!)
        id = reponse["id"] as? Int
        lookup = reponse["lookup"] as? String
        printItem = reponse["printItem"] as? Bool
        openItem = reponse["openItem"] as? Bool
        usesWeightScale = reponse["usesWeightScale"] as? Bool
        weighted = reponse["weighted"] as? Bool
        tareWeight = reponse["tareWeight"] as? Int
        itemShortName = reponse["itemShortName"] as? String
        qtyOnHand = reponse["qtyOnHand"] as? Int
        icon = reponse["icon"] as? String
        color = reponse["color"] as? String
        active = reponse["active"] as? Bool
        isGift = reponse["isGift"] as? Bool
        inheritTaxes = reponse["inheritTaxes"] as? Bool
        locationId = reponse["locationId"] as? Int
        minQty = reponse["minQty"] as? Int
        deptOpenKey = reponse["deptOpenKey"] as? Bool
        ebtItem = reponse["ebtItem"] as? Bool
        itemTags = reponse["itemTags"] as? String
        unit = reponse["unit"] as? String

    }
}