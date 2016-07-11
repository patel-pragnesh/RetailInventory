//
//  StoreSetupMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/14/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import UIKit

enum StoreSetupCells: Int {
    case department = 0, vendors, taxes, cost, lookup, clear, restore
    static let count: Int = {
        var max: Int = 0
        while let _ = StoreSetupCells(rawValue: max) { max += 1 }
        return max
    }()
}

enum parametersCell: Int {
    case segueCell = 0, switchCell, infoCell, defaultCell
}

class StoreSetupData: EntityMethods<StoreSetup>{
    init() {
        var array = [StoreSetup]()
        for index in 0...StoreSetupCells.count - 1 {
            switch StoreSetupCells(rawValue: index)! {
            case .department:
                array.append(StoreSetup(title: "storeSetup.departments".localized, info: String(DepartmentData.getCountFromDB()) + "storeSetup.conf".localized, image: UIImage(named: "dept")!, hiddenSwitch: true, hiddenArrow: false))
            case .vendors:
                array.append(StoreSetup(title: "storeSetup.vendors".localized, info: String(VendorData.getCountFromDB()) + "storeSetup.conf".localized, image: UIImage(named: "vendors")!, hiddenSwitch: true, hiddenArrow: false))
            case .taxes:
                array.append(StoreSetup(title: "storeSetup.taxes".localized, info: String(TaxData.getCountFromDB()) + "storeSetup.conf".localized, image: UIImage(named: "taxes")!, hiddenSwitch: true, hiddenArrow: false))
            case .cost:
                array.append(StoreSetup(title: "storeSetup.cost".localized, info: nil, image: UIImage(named: "cost")!, hiddenSwitch: false, hiddenArrow: true))
            case .lookup:
                array.append(StoreSetup(title: "storeSetup.lookup".localized, info: nil, image: UIImage(named: "iconStoreLookup")!, hiddenSwitch: false, hiddenArrow: true))
            case .clear:
                array.append(StoreSetup(title: "storeSetup.clear".localized, info: String(InventoryListData.getCountFromDB()) + "storeSetup.conf".localized, image: nil, hiddenSwitch: true, hiddenArrow: true))
            case .restore:
                array.append(StoreSetup(title: "storeSetup.restore".localized, info: nil, image: nil, hiddenSwitch: true, hiddenArrow: true))
            }
        }
        
        super.init(array: array)
    }
    
    static func segueName(storeSetupCell: StoreSetupCells) -> String? {
        switch storeSetupCell {
        case .department:
            return MyConstant.segueDepartments
        case .vendors:
            return MyConstant.segueVendors
        case .taxes:
            return MyConstant.segueTaxes
        default:
            return nil
        }
    }
    
    static func enumCells(index: Int) -> StoreSetupCells{
        return StoreSetupCells(rawValue: index)!
    }
    
    static func parameterCell(cell: StoreSetupCells) -> parametersCell {
        switch cell {
        case .department,
             .vendors,
             .taxes:
            return parametersCell.segueCell
        case .cost,
             .lookup:
            return parametersCell.switchCell
        case .clear:
            return parametersCell.infoCell
        case .restore:
            return parametersCell.defaultCell
        }
    }
}