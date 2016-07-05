//
//  InventoryList+CoreDataProperties.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/21/16.
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
    @NSManaged var list_description: String?
    @NSManaged var merchantID: String?
    @NSManaged var needUpdate: NSNumber?
    @NSManaged var price: String?
    @NSManaged var listDepartment: Department?
    @NSManaged var listVendor: Vendor?
    @NSManaged var listTax: Tax?
    @NSManaged var adjustStockLevels: AdjustStockLevels?
    
    subscript(key: String) -> AnyObject? {
        get {
            switch key {
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
            default:
                return nil
            }
        }
        set(value) {
            switch key {
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
                needUpdate = value as? NSNumber
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