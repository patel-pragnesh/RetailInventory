//
//  Tax+CoreDataProperties.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/6/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tax {

    @NSManaged var taxName: String?
    @NSManaged var taxValue: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var active: NSNumber?
    @NSManaged var inventoryList: NSSet?
    @NSManaged var department: NSSet?
    
    subscript(key: String) -> AnyObject? {
        get {
            switch key {
            case "name":
                return taxName
            case "value":
                return taxValue
            case "id":
                return id
            case "active":
                return active
            case "inventory":
                return inventoryList
            default:
                return nil
            }
        }
        set(value) {
            switch key {
            case "name":
                taxName = value as? String
            case "value":
                taxValue = value as? Double
            case "id":
                id = value as? Int
            case "active":
                active = value as? Bool
            default: assert(true, "you do something wrong")
            }
        }
    }

}
