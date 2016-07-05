//
//  AddDepartmentsMethods.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum DepartmentCell: Int {
    case name = 0, id, active, icon, ebt, taxes, items
    static let count: Int = {
        var max: Int = 0
        while let _ = DepartmentCell(rawValue: max) { max += 1 }
        return max
    }()
}

class AddDepartmentsMethods: EntityMethods<String>{
    
    enum CellType: Int {
        case inputText = 0, switchCell, icon, link
    }
    
    init() {
        var array = [String]()
        for index in 0...DepartmentCell.count - 1 {
            switch DepartmentCell(rawValue: index)! {
            case .name:
                array.append("addDepart.name".localized)
            case .id:
                array.append("addDepart.id".localized)
            case .active:
                array.append("addDepart.active".localized)
            case .icon:
                array.append("addDepart.icon".localized)
            case .ebt:
                array.append("addDepart.ebt".localized)
            case .taxes:
                array.append("addDepart.taxes".localized)
            case .items:
                array.append("addDepart.items".localized)
            }
        }
        super.init(array: array)
    }
    
    func enumCell(index: Int) -> DepartmentCell{
        return DepartmentCell(rawValue: index)!
    }
    
    func parameterCell(cell: DepartmentCell) -> CellType {
        switch cell {
        case .name,
             .id:
            return .inputText
        case .active,
             .ebt:
            return .switchCell
        case .icon:
            return .icon
        case .taxes,
             .items:
            return .link
        }
    }
    
    func segueName(departmentCell: DepartmentCell) -> String? {
        switch departmentCell {
        case .icon:
            return MyConstant.segueIcon
        case .taxes:
            return MyConstant.segueAppliedTaxes
        case .items:
            return MyConstant.segueAppliedItems
        default:
            return nil
        }
    }
}