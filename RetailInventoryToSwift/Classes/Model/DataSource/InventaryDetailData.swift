//
//  InventoryDetailMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/17/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum DetailName: Int {
    case active = 0, name, shortName, department, vendor, taxes, price, cost, qtyOnHand, icon, color, barcode, description, printItem, openItem, usesWeightScale, weighted, tareWeight, tag, set
    static let count: Int = {
        var max: Int = 0
        while let _ = DetailName(rawValue: max) { max += 1 }
        return max
    }()
}

enum DetailCellType: Int {
    case editNumber = 0, editWord, label, switchCell
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
        array[DetailName.printItem.rawValue] = "inventoryDetail.printItem".localized
        array[DetailName.openItem.rawValue] = "inventoryDetail.openItem".localized
        array[DetailName.usesWeightScale.rawValue] = "inventoryDetail.usesWeightScale".localized
        array[DetailName.weighted.rawValue] = "inventoryDetail.weighted".localized
        array[DetailName.tareWeight.rawValue] = "inventoryDetail.tareWeight".localized
        array[DetailName.color.rawValue] = "inventoryDetail.color".localized
        array[DetailName.icon.rawValue] = "inventoryDetail.icon".localized
        array[DetailName.name.rawValue] = "inventoryDetail.name".localized
        array[DetailName.shortName.rawValue] = "inventoryDetail.shortName".localized
        array[DetailName.active.rawValue] = "inventoryDetail.active".localized
        array[DetailName.qtyOnHand.rawValue] = "inventoryDetail.qtyOnHand".localized
        array[DetailName.tag.rawValue] = "inventoryDetail.tag".localized
        array[DetailName.set.rawValue] = "inventoryDetail.set".localized
        
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
        case .tag:
            return MyConstant.segueSelectTag
        case .set:
            return MyConstant.segueSelectSet
        default:
            return nil
        }
    }
    
    static func parameterCell(cell: DetailName) -> DetailCellType {
        switch cell {
        case .barcode, .description, .name, .shortName:
            return .editWord
        case .department, .vendor, .taxes, .icon, .color, .tag, .set:
            return .label
        case  .price, .cost, .tareWeight, .qtyOnHand:
            return .editNumber
        case .printItem, .openItem, .usesWeightScale, .active, .weighted:
            return .switchCell
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
        case .printItem:
            return "printItem"
        case .openItem:
            return "openItem"
        case .usesWeightScale:
            return "usesWeightScale"
        case .weighted:
            return "weighted"
        case .tareWeight:
            return "tareWeight"
        case .shortName:
            return "itemShortName"
        case .qtyOnHand:   // TODO rename in CoreData
            return "gtyOnHand"
        case .icon:
            return "icon"
        case .color:
            return "color"
        case .active:
            return "active"
        case .name:
            return "name"
        case .tag:
            return "listTag"
        case .set:
            return "listSet"
        }
    }
}