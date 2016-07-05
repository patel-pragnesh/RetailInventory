//
//  InventoryDetailMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/17/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum DetailName: Int {
    case barcode = 0, description, department, vendor, taxes, price, cost
}

class InventoryDetailMethods: EntityMethods<String> {
    
    init() {
        var array = [String](count: DetailName.cost.rawValue + 1,  repeatedValue: "")
        array[DetailName.barcode.rawValue] = "inventoryDetail.barCode".localized
        array[DetailName.description.rawValue] = "inventoryDetail.description".localized
        array[DetailName.department.rawValue] = "inventoryDetail.department".localized
        array[DetailName.vendor.rawValue] = "inventoryDetail.vendor".localized
        array[DetailName.taxes.rawValue] = "inventoryDetail.taxes".localized
        array[DetailName.price.rawValue] = "inventoryDetail.price".localized
        array[DetailName.cost.rawValue] = "inventoryDetail.cost".localized
        
        super.init(array: array)
    }
}