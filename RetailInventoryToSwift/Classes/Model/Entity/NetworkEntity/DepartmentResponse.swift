//
//  DepartmentResponse.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/1/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct DepartmentResponse {
    var name: String
    var id: Int
    var active: Bool
    var ebtItem: Bool
    var glyph: String
    var taxesId: [Int]?
    var ecrKey: Bool?
    var hidden: Bool?
    var locationId: Int?
    var ordinalNum: Int?
    var sortMode: Bool?
    
    init(withDictionary response: [String: AnyObject]) {
        
        let taxes = response["taxes"] as? [AnyObject]
        var arrayID = [Int]()
        taxes!.forEach({tax in
            arrayID.append((tax["id"] as? Int)!)
        })
        
        name = (response["name"] as? String)!
        id = (response["id"] as? Int)!
        active = (response["active"] as? Bool)!
        ebtItem = (response["ebtItem"] as? Bool)!
        glyph = (response["glyph"] as? String)!
        taxesId = arrayID       
    }
}