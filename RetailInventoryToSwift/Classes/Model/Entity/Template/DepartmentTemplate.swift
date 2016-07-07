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
    
    func asDictionaryForRequest() -> [String:AnyObject] {
        var department = [String:AnyObject]()
        department["active"] = self.active
        department["ebtItem"] = self.itemsEbt
        department["name"] = self.name
        department["id"] = self.id
        if let icon = self.icon {
            let ch = icon.unicodeScalars
            department["glyph"] = String(ch[ch.startIndex].value, radix: 16)
        }
        return department
    }
    
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