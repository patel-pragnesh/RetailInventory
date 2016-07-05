//
//  Vendor+CoreDataProperties.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 29.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Vendor {

    @NSManaged var accountNumber: String?
    @NSManaged var alias: String?
    @NSManaged var city: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var state: String?
    @NSManaged var street: String?
    @NSManaged var zip: String?
    @NSManaged var inventoryList: NSSet?
    
    subscript(key: String) -> AnyObject? {
        get {
            switch key {
            case "accountNumber":
                return accountNumber
            case "alias":
                return alias
            case "city":
                return city
            case "name":
                return name
            case "phone":
                return phone
            case "state":
                return state
            case "street":
                return street
            case "zip":
                return zip
            default:
                return nil
            }
        }
        set(value) {
            switch key {
            case "accountNumber":
                accountNumber = value as? String
            case "alias":
                alias = value as? String
            case "city":
                city = value as? String
            case "name":
                name = value as? String
            case "phone":
                phone = value as? String
            case "state":
                state = value as? String
            case "street":
                street = value as? String
            case "zip":
                zip = value as? String
            default: assert(true, "you do something wrong")
            }
        }
    }
}
