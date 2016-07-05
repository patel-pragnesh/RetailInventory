//
//  TaxMethhods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class TaxData: EntityMethods<Tax> {
    
    init() {
        let taxs = Tax.MR_findAllSortedBy("taxName", ascending: true) as! [Tax]
        super.init(array: taxs)
    }
    
    func addObject() -> Tax {
        let newTax = Tax.MR_createEntity()!
        array.append(newTax)
        return newTax
    }
    
    func removeObject(tax: Tax) {
        tax.MR_deleteEntity()
    }
    
    func editObject(old: Tax, new: Tax) -> Bool {
        let index = array.indexOf(old)
        if index != nil {
            array[index!] = new
            return true
        } else {
            return false
        }
    }
}