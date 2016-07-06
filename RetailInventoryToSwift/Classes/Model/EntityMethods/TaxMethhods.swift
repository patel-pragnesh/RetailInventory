//
//  TaxMethhods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum TaxField: String {
    case taxName = "name",
         taxValue = "value",
         inventory = "inventory"
}

class TaxMethods: EntityMethods<Tax> {
    
    init() {
        let taxs = DataManager.fetchAllTax()
        super.init(array: taxs)
    }
    
    func addTax(taxName: String?,
                taxValue: NSNumber?) -> Tax {
        return DataManager.addTax(taxName, taxValue: taxValue)
    }
    
    func removeTax(tax: Tax) {
        DataManager.deleteTax(tax)
    }
    
    func getIndexByName(name: String) -> Int {
        var i: Int = 0
        for tax in array {
            if tax.taxName == name {
                return i
            }
            i += 1
        }
        return -1
    }
    
    func getIndex(tax: Tax) -> Int? {
        var i: Int = 0
        for taxArray in array {
            if taxArray == tax {
                return i
            }
            i += 1
        }
        return nil
    }
    
    func updateTaxes(serverTaxes: [TaxResponse]) {
        for serverTax in serverTaxes {
            let index = getIndexByName(serverTax.name)
            switch index {
            case -1:
                addTax(serverTax.name, taxValue: serverTax.percent)
            default:
                editTaxWithResponse(at: array[index], taxResponse: serverTax)
            }
        }
        
        for localTax in array {
            var isConsist = false
            for serverTax in serverTaxes {
                if localTax.taxName == serverTax.name {
                    isConsist = true
                }
            }
            if !isConsist {
                removeTax(localTax)
            }
        }
        
        DataManager.saveContext()
    }
    
    override func refresh() {
        array = DataManager.fetchAllTax()
    }
    
    static func getCountFromDB() -> UInt {
        return DataManager.getCountTax()
    }
    static func editTax(fieldName: TaxField, at tax: Tax, value: AnyObject?) {
        tax[fieldName.rawValue] = value
        self.save()
    }
    
    func editTaxWithResponse(at tax: Tax, taxResponse: TaxResponse) {
        tax.taxName = taxResponse.name
        tax.taxValue = taxResponse.percent
        tax.id = taxResponse.id
        tax.active = taxResponse.active
    }
    static func updateTaxesWithDepartmentResponse(department: Department, taxesId: [Int]?) {
        let taxes = DataManager.fetchAllTax()
        if let ids = taxesId {
            for id in ids {
                for tax in taxes {
                    if tax.id == id {
                        var deps = tax.department?.allObjects as! [Department]
                        if  !deps.contains(department) {
                            deps.append(department)
                        }
                        tax.department = NSSet(array: deps)
                    }
                }
            }
            DataManager.saveContext()
        }
        
    }
    
    static func taxesByDepartment(departmentID: NSNumber) -> [Tax] {
        return DataManager.getTaxesByDepartment(departmentID)
    }
}