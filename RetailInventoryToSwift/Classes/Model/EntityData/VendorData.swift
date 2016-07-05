//
//  VendorMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class VendorData: EntityMethods<Vendor> {
    
    init() {
        let vendors = Vendor.MR_findAllSortedBy("accountNumber", ascending: true) as! [Vendor]
        super.init(array: vendors)
    }
    
    func addObject() -> Vendor {
        let newVendor = Vendor.MR_createEntity()!
        array.append(newVendor)
        return newVendor
    }
    
    func removeObject(vendor: Vendor) {
        vendor.MR_deleteEntity()
    }
    
    func editObject(old: Vendor, new: Vendor) -> Bool {
        let index = array.indexOf(old)
        if index != nil {
            array[index!] = new
            return true
        } else {
            return false
        }
    }
}