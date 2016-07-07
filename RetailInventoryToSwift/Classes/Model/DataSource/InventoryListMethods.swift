//
//  InventoryListMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

enum InventoryListField: String {
    case barcode = "barcode",
        cost = "cost",
        descriptopn = "list_description",
        merchandID = "merchandID",
        price = "price",
        needUpdate = "needUpdate",
        listDepartment = "listDepartment",
        listVendor = "listVendor",
        listTax = "listTax",    
        adjustStockLevels = "adjustStockLevels"
}

class InventoryListMethods: EntityMethods<InventoryList> {
    
    init() {
        let inventorys = DataManager.fetchAllInventoryList()
        super.init(array: inventorys)
    }
    
    static func addInventory(barcode: String?) -> InventoryList {
         return DataManager.addInventoryList(barcode)
    }
           
    static func removeInventory(inventory: InventoryList) -> Bool {
        return DataManager.deleteInventoryList(inventory)
    }
    
    override func refresh() {
        array = DataManager.fetchAllInventoryList()
    }
    
    func getIndex(obj: InventoryList) -> Int? {
        var i: Int = 0
        for object in array {
            if object === obj {
                return i
            }
            i += 1
        }
        return nil
    }
    
    func sort(sort: SortButton) {
        switch sort {
        case .all:
            array = array.sort({ $0.barcode < $1.barcode})
        case .vendor:
            array = array.sort({ $0.listVendor?.name < $1.listVendor?.name})
        case .departments:
            array = array.sort({ $0.listDepartment?.name < $1.listDepartment?.name})
        }
    }
    
    static func detailInventoy(detail: DetailName, at inventory: InventoryList) -> AnyObject? {
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
    
    static func getInventoryByBarcode(barcode: String) -> InventoryList {
        return DataManager.getFirstByAttribute("barcode", value: barcode)
    }
    
    static func editInventory(fieldName: InventoryListField, at inventory: InventoryList, value: AnyObject?) {
        inventory[fieldName.rawValue] = value
        self.save()
    }
    
    static func removeAll() -> Bool {
        return DataManager.removaAllInventoryList()
    }
    
    static func getCountFromDB() -> UInt {
        return DataManager.getCountInventoryList()
    }
    static func itemsByDepartment(departmentID: NSNumber) -> [InventoryList] {
        return DataManager.getInventoryByDepartment(departmentID)
    }
}