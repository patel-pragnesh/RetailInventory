//
//  DepartmentTemplate.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/4/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

struct DepartmentTemplate {
    var name: String?
    var id: NSNumber?
    var icon: String?
    var active: NSNumber?
    var itemsEbt: NSNumber?
    
    subscript(key: String) -> AnyObject? {
        get {
            switch key {
            case "active":
                return active
            case "icon":
                return icon
            case "id":
                return id
            case "itemsEbt":
                return itemsEbt
            case "name":
                return name
            default:
                return nil
            }
        }
        set(value) {
            switch key {
            case "active":
                active = value as? NSNumber
            case "icon":
                icon = value as? String
            case "id":
                id = value as? NSNumber
            case "itemsEbt":
                itemsEbt = value as? NSNumber
            case "name":
                name = value as? String
            default: assert(true, "you do something wrong")
            }
        }
    }
}