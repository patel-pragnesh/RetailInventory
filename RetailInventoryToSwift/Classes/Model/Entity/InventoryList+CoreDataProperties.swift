//
//  InventoryList+CoreDataProperties.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/11/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension InventoryList {

    @NSManaged var barcode: String?
    @NSManaged var cost: String?
    @NSManaged var id: NSNumber?
    @NSManaged var list_description: String?
    @NSManaged var merchantID: String?
    @NSManaged var name: String?
    @NSManaged var needUpdate: NSNumber?
    @NSManaged var price: String?
    @NSManaged var active: NSNumber?
    @NSManaged var printItem: NSNumber?
    @NSManaged var openItem: NSNumber?
    @NSManaged var usesWeightScale: NSNumber?
    @NSManaged var weighted: NSNumber?
    @NSManaged var tareWeight: NSNumber?
    @NSManaged var itemShortName: String?
    @NSManaged var gtyOnHand: NSNumber?
    @NSManaged var icon: String?
    @NSManaged var color: String?
    @NSManaged var adjustStockLevels: AdjustStockLevels?
    @NSManaged var listDepartment: Department?
    @NSManaged var listTax: Tax?
    @NSManaged var listVendor: Vendor?
    @NSManaged var listSets: Set?
    @NSManaged var listTags: Tag?
    
    subscript(key: String) -> AnyObject? {
        get {
            switch key {
            case "name":
                return name
            case "printItem":
                return printItem
            case "openItem":
                return openItem
            case "usesWeightScale":
                return usesWeightScale
            case "weighted":
                return weighted
            case "tareWeight":
                return tareWeight
            case "itemShortName":
                return itemShortName
            case "gtyOnHand":   // TODO rename in CoreData
                return gtyOnHand
            case "icon":
                return icon
            case "color":
                return color
            case "active":
                return active
            case "id":
                return id
            case "barcode":
                return barcode
            case "cost":
                return cost
            case "list_description":
                return list_description
            case "merchandID":
                return merchantID
            case "price":
                return price
            case "needUpdate":
                return needUpdate
            case "listDepartment":
                return listDepartment
            case "listVendor":
                return listVendor
            case "listTax":
                return listTax
            case "adjustStockLevels":
                return adjustStockLevels
            case "listSet":
                return listSets
            case "listTag":
                return listTags
            default:
                return nil
            }
        }
        set(value) {
            switch key {
            case "printItem":
                printItem = value as? Bool
            case "openItem":
                openItem = value as? Bool
            case "usesWeightScale":
                usesWeightScale = value as? Bool
            case "weighted":
                weighted = value as? Bool
            case "tareWeight":
                tareWeight = value as? Int
            case "itemShortName":
                itemShortName = value as? String
            case "gtyOnHand":   // TODO rename in CoreData
                gtyOnHand = value as? Int
            case "icon":
                icon = value as? String
            case "color":
                color = value as? String
            case "active":
                active = value as? Bool
            case "id":
                id = value as? Int
            case "barcode":
                barcode = value as? String
            case "cost":
                cost = value as? String
            case "list_description":
                list_description = value as? String
            case "merchandID":
                merchantID = value as? String
            case "price":
                price = value as? String
            case "needUpdate":
                needUpdate = value as? Bool
            case "listDepartment":
                listDepartment = value as? Department
            case "listVendor":
                listVendor = value as? Vendor
            case "listTax":
                listTax = value as? Tax
            case "adjustStockLevels":
                adjustStockLevels = value as? AdjustStockLevels
            default: assert(true, "you do something wrong")
            }
        }
    }

}
