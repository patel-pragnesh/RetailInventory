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

class InventoryDetailData: EntityMethods<String> {
    
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
    
    func segueName(index: Int) -> String? {
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
    
   
    func parameterCell(cell: DetailName) -> DetailCellType {
        switch cell {
            case .barcode, .description:
                return .editWord
            case .department, .vendor, .taxes:
                return .label
        case  .price, .cost:
            return .editNumber
        }
    }
    
    func detailInventoy(detail: DetailName, at inventory: InventoryList) -> AnyObject? {
        switch detail {
        case .barcode:
            return inventory.barcode
        case .cost:
            return inventory.cost
        case .department:
            return inventory.listDepartment?.name
        case .description:
            return inventory.list_description
        case .price:
            return inventory.price
        case .taxes:
            return inventory.listTax?.taxName
        case .vendor:
            return inventory.listVendor?.name
        }
    }
    
    func valueForInventory(detail: DetailName, at inventory: InventoryList, value: AnyObject?) {
        switch detail {
        case .barcode:
            inventory.barcode = value as? String
        case .cost:
            inventory.cost = value as? String
        case .department:
            inventory.listDepartment = value as? Department
        case .description:
            inventory.list_description = value as? String
        case .price:
            inventory.price = value as? String
        case .taxes:
            inventory.listTax = value as? Tax
        case .vendor:
            inventory.listVendor = value as? Vendor
        }
        
    }
}