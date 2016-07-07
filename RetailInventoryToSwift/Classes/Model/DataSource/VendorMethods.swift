//
//  VendorMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum VendorField: String {
    case accountNumber = "accountNumber",
    alias = "alias",
    city = "city",
    name = "name",
    phone = "phone",
    state = "state",
    street = "street",
    zip = "zip"
}

class VendorMethods: EntityMethods<Vendor> {
    
    init() {
        let vendors = DataManager.fetchAllVendor()
        super.init(array: vendors)
    }
    
    static func addVendor(accountNumber: String?,
                          alias: String?,
                          city: String?,
                          name: String?,
                          phone: String?,
                          state: String?,
                          street: String?,
                          zip: String?) -> Vendor {
        return DataManager.addVendor(accountNumber, alias: alias, city: city, name: name, phone: phone, state: state, street: street, zip: zip)
    }
    
    func addFromTemplate(template: VendorTemplate) {
        DataManager.addVendor(template.accountNumber, alias: template.alias, city: template.city, name: template.name, phone: template.phone, state: template.state, street: template.street, zip: template.zip)
    }
    
    func editFromTemplate(vendor: Vendor, template: VendorTemplate) {
        vendor.accountNumber = template.accountNumber
        vendor.alias = template.alias
        vendor.city = template.city
        vendor.name = template.name
        vendor.phone = template.phone
        vendor.state = template.state
        vendor.street = template.street
        
        DataManager.saveContext()
    }
    
    func editVendor(index: Int, newVendor: Vendor) {
        array[index] = newVendor
        DataManager.saveContext()
    }
    
    func removeVendor(vendor: Vendor) {
        DataManager.deleteVendor(vendor)
    }
    
    override func refresh() {
        array = DataManager.fetchAllVendor()
    }
    
    static func getCountFromDB() -> UInt {
        return DataManager.getCountVendor()
    }
    
    static func fieldDetail(fieldName: VendorField, vendor: VendorTemplate) -> String? {
        return vendor[fieldName.rawValue] as? String
    }
}