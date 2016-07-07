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
    static let count: Int = {
        var max: Int = 0
        while let _ = DetailName(rawValue: max) { max += 1 }
        return max
    }()
}

enum DetailCellType: Int {
    case editNumber = 0, editWord, label
}

class InventoryDetailMethods: EntityMethods<String> {
    
    init() {
        var array = [String](count: DetailName.count,  repeatedValue: "")
        array[DetailName.barcode.rawValue] = "inventoryDetail.barCode".localized
        array[DetailName.description.rawValue] = "inventoryDetail.description".localized
        array[DetailName.department.rawValue] = "inventoryDetail.department".localized
        array[DetailName.vendor.rawValue] = "inventoryDetail.vendor".localized
        array[DetailName.taxes.rawValue] = "inventoryDetail.taxes".localized
        array[DetailName.price.rawValue] = "inventoryDetail.price".localized
        array[DetailName.cost.rawValue] = "inventoryDetail.cost".localized
        
        super.init(array: array)
    }
    
    static func segueName(index: Int) -> String? {
        switch DetailName(rawValue: index)! {
        case .department:
            return MyConstant.segueSelectDepartments
        case .vendor:
            return MyConstant.segueSelectVendors
        case .taxes:
            return MyConstant.segueSelectTaxes
        default:
            return nil
        }
    }
    
    static func parameterCell(cell: DetailName) -> DetailCellType {
        switch cell {
        case .barcode,
             .description:
            return .editWord
        case .department,
             .vendor,
             .taxes:
            return .label
        case  .price, .cost:
            return .editNumber
        }
    }
    
    static func fieldNameForDetail(detail: DetailName) -> String {
        switch detail {
        case .barcode:
            return "barcode"
        case .description:
            return "list_description"
        case .department:
            return "listDepartment"
        case .vendor:
            return "listVendor"
        case .taxes:
            return "listTax"
        case .price:
            return "price"
        case .cost:
            return "cost"
        }
    }
}