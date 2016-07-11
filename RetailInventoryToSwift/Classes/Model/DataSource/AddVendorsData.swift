//
//  AddVendorsMethods.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class AddVendorsData: EntityMethods<AddVendors>{
    
    enum VendorCell: Int {
        case name = 0, alias, street, сity, state, zip, accountNumber, phone
        static let count: Int = {
            var max: Int = 0
            while let _ = VendorCell(rawValue: max) { max += 1 }
            return max
        }()
    }
    
    init() {
        var array = [AddVendors]()
        for index in 0...VendorCell.count - 1 {
            switch VendorCell(rawValue: index)! {
            case .name:
                array.append(AddVendors.init(title: "addVendor.name".localized))
            case .alias:
                array.append(AddVendors.init(title: "addVendor.alias".localized))
            case .street:
                array.append(AddVendors.init(title: "addVendor.street".localized))
            case .сity:
                array.append(AddVendors.init(title: "addVendor.сity".localized))
            case .state:
                array.append(AddVendors.init(title: "addVendor.state".localized))
            case .zip:
                array.append(AddVendors.init(title: "addVendor.zip".localized))
            case .accountNumber:
                array.append(AddVendors.init(title: "addVendor.accountNumber".localized))
            case .phone:
                array.append(AddVendors.init(title: "addVendor.phone".localized))
            }
        }
        super.init(array: array)
    }
    
    func enumCell(index: Int) -> VendorCell{
        return VendorCell(rawValue: index)!
    }
    
    static func fieldNameForDetail(detail: VendorCell) -> String{
        switch detail {
        case .name:
            return "name"
        case .alias:
            return "alias"
        case .сity:
            return "city"
        case .phone:
            return "phone"
        case .state:
            return "state"
        case .street:
            return "street"
        case .zip:
            return "zip"
        case .accountNumber:
            return "accountNumber"
        }
    }
    
    static func placeHolderForCell(detail: VendorCell) -> String {
        switch detail {
        case .name:
            return "addVendor.enName".localized
        case .alias:
            return "addVendor.enAlias".localized
        case .сity:
            return "addVendor.enCity".localized
        case .phone:
            return "addVendor.enNumberPhone".localized
        case .state:
            return "addVendor.enState".localized
        case .street:
            return "addVendor.enStreet".localized
        case .zip:
            return  "addVendor.enZip".localized
        case .accountNumber:
            return "addVendor.enAccountNum".localized
        }
    }
}