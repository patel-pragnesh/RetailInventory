//
//  DataManager.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/22/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import MagicalRecord

class DataManager {
    
    static func fetchAllInventoryList() -> [InventoryList] {
        return InventoryList.MR_findAllSortedBy("barcode", ascending: true) as! [InventoryList]
    }
    
    // MARK: - InventoryList
   
    static func deleteInventoryList(inventoyList: InventoryList) -> Bool {
        let result = inventoyList.MR_deleteEntity()
        saveContext()
        return result
    }
    
    static func addInventoryList(barcode: String?) -> InventoryList {
        let newInventory = InventoryList.MR_createEntity()!
        newInventory.barcode = barcode
        
        saveContext()
        return newInventory
    }
    
    static func getFirstByAttribute(attribute: String, value: AnyObject) -> InventoryList {
        return InventoryList.MR_findFirstByAttribute(attribute, withValue: value)!
    }
    
    static func getInventoryByDepartment(departmentID: NSNumber) -> [InventoryList] {
        let predicate = NSPredicate(format: "listDepartment.id = %@", departmentID)
        let array = InventoryList.MR_findAllWithPredicate(predicate)
        return array as! [InventoryList]
    }
    
    static func removaAllInventoryList() -> Bool {
        let result = InventoryList.MR_truncateAll()
        saveContext()
        return result
    }
    
    static func getCountInventoryList() -> UInt {
        return InventoryList.MR_countOfEntities()
    }
    
    // MARK: - Department
    
    static func fetchAllDepartment() -> [Department] {
        return Department.MR_findAllSortedBy("name", ascending: true) as! [Department]
    }
    
    static func deleteDepartment(department: Department) -> Bool {
        let result = department.MR_deleteEntity()
        saveContext()
        return result
    }
    
    static func getFirstDepartmentByAttribute(attribute: String, value: AnyObject) -> Department {
        return Department.MR_findFirstByAttribute(attribute, withValue: value)!
    }
    
    static func addDepartment(name: String?, id: NSNumber?, icon: String?, active: NSNumber?, itemsEbt: NSNumber?) -> Department {
        let newDepartment = Department.MR_createEntity()!
        newDepartment.name = name
        newDepartment.id = id
        newDepartment.icon = icon
        newDepartment.active = active
        newDepartment.itemsEbt = itemsEbt
        
        saveContext()
        
        return newDepartment
    }
    
    static func getCountDepartment() -> UInt {
        return Department.MR_countOfEntities()
    }
    
    // MARK: - Vendor
    
    static func fetchAllVendor() -> [Vendor] {
        return Vendor.MR_findAllSortedBy("name", ascending: true) as! [Vendor]
    }
    
    static func deleteVendor(vendor: Vendor) -> Bool {
        return vendor.MR_deleteEntity()
    }
    
    static func addVendor(accountNumber: String?,
                   alias: String?,
                   city: String?,
                   name: String?,
                   phone: String?,
                   state: String?,
                   street: String?,
                   zip: String?) -> Vendor {
        let newVendor = Vendor.MR_createEntity()!
        newVendor.accountNumber = accountNumber
        newVendor.alias = alias
        newVendor.city = city
        newVendor.name = name
        newVendor.phone = phone
        newVendor.state = state
        newVendor.street = street
        newVendor.zip = zip
        
        saveContext()
        
        return newVendor
    }
    
    static func getCountVendor() -> UInt {
        return Vendor.MR_countOfEntities()
    }
    
    // MARK: - Tax
    
    static func fetchAllTax() -> [Tax] {
        return Tax.MR_findAllSortedBy("taxName", ascending: true) as! [Tax]
    }
    
    static func getFirstTaxByAttribute(attribute: String, value: AnyObject) -> Tax? {
        return Tax.MR_findFirstByAttribute(attribute, withValue: value)
    }
    
    static func deleteTax(tax: Tax) -> Bool {
        return tax.MR_deleteEntity()
    }
    
    static func addTax(taxName: String?,
                taxValue: NSNumber?) -> Tax {
        let newTax = Tax.MR_createEntity()!
        newTax.taxName = taxName
        newTax.taxValue = taxValue
        
        saveContext()
        return newTax
    }
    
    
    static func getCountTax() -> UInt {
        return Tax.MR_countOfEntities()
    }
    
    static func getTaxesByDepartment(departmentID: NSNumber) -> [Tax] {
        let predicate = NSPredicate(format: "ANY department == %@", getFirstDepartmentByAttribute("id", value: departmentID))
        let array = Tax.MR_findAllWithPredicate(predicate)
        return array as! [Tax]
    }
    
    // MARK: - Common
    
    static func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}