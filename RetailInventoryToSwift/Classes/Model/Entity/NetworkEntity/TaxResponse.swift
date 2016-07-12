//
//  TaxResponse.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/1/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct TaxResponse {
    var name: String?
    var percent: Double?
    var id: NSNumber?
    var active: Bool?
    var defaultTax: Bool?
    var hidden: Bool?
    var locationId: Int?
    
    init(withDictionary response: [String: AnyObject]) {
        name = response["name"] as? String
        percent = response["percent"] as? Double
        id = response["id"] as? Int
        active = response["active"] as? Bool
        defaultTax = response["defaultTax"] as? Bool
        hidden = response["hidden"] as? Bool
    }
}