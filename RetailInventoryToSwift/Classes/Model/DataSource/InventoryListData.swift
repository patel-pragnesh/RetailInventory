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
        id = "id",
        name = "name",
        descriptopn = "list_description",
        merchandID = "merchandID",
        price = "price",
        needUpdate = "needUpdate",
        listDepartment = "listDepartment",
        listVendor = "listVendor",
        listTax = "listTax",    
        adjustStockLevels = "adjustStockLevels",
        printItem = "printItem",
        openItem = "openItem",
        usesWeightScale = "usesWeightScale",
        weighted = "weighted",
        tareWeight = "tareWeight",
        itemShortName = "itemShortName",
        qtyOnHand = "gtyOnHand",
        icon = "icon",
        color = "color",
        active = "active",
        listTags = "listTag",
        listSet = "listSet"
}

class InventoryListData: EntityMethods<InventoryList> {
    
    init() {
        let inventorys = DataManager.fetchAllInventoryList()
        super.init(array: inventorys)
    }
    
    static func addInventory(barcode: String?) -> InventoryList {
         return DataManager.addInventoryList(barcode)
    }
    
    

    static func addInventory(cost: String?, list_description: String?, price: String?, id: Int?, name: String?, departmentId: Int?, barcode: String?) -> InventoryList {
        var depId: Int?
        if departmentId == 0 {
            depId = nil
        } else {
            depId = departmentId
        }
        return DataManager.addInventoryList(cost, list_description: list_description, price: price, id: id, name: name, departmentId: depId, barcode: barcode)
    }
    
    static func addInventoryFromResponse(items: [ItemResponse]) {
        let inventorys = DataManager.fetchAllInventoryList()
        for item in items {
            var isConsist = false
            for inventory in inventorys {
                if inventory.id == item.id {
                    isConsist = true
                    updateInventory(inventory, fromResponse: item)
                    if item.departmentId != 0 {
                        editInventory(InventoryListField.listDepartment, at: inventory, value: DepartmentData.departmentBy(item.departmentId!))
                    }
                }
            }
            if !isConsist {
                addInventory(item.cost, list_description: item.itemNotes, price: item.price, id: item.id, name: item.itemName, departmentId: item.departmentId, barcode: item.barcode)
            }
        }
        save()
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
        case .active:
            return inventory.active
        case .printItem:
            return inventory.printItem
        case .openItem:
            return inventory.openItem
        case .tareWeight:
            return inventory.tareWeight
        case .usesWeightScale:
            return inventory.usesWeightScale
        case .weighted:
            return inventory.weighted
        case .icon:
            return inventory.icon
        case .color:
            return inventory.color
        case .qtyOnHand:
            return inventory.gtyOnHand
        case .name:
            return inventory.name
        case .shortName:
            return inventory.itemShortName
        case .tag:
            return inventory.listTags?.itemTagDesc
        case .set:
            return inventory.listSets?.name
        }
    }
    
    static func getInventoryByBarcode(barcode: String) -> InventoryList {
        return DataManager.getFirstByAttribute("barcode", value: barcode)
    }
    
    static func editInventory(fieldName: InventoryListField, at inventory: InventoryList, value: AnyObject?) {
        inventory[fieldName.rawValue] = value
        self.save()
    }
    
    static func updateInventory(inventory: InventoryList, fromResponse serverInventory: ItemResponse) {
        inventory.active = serverInventory.active
        inventory.barcode = serverInventory.barcode
        inventory.color = serverInventory.color
        inventory.cost = serverInventory.cost
        inventory.gtyOnHand = serverInventory.qtyOnHand
        inventory.icon = serverInventory.icon
        inventory.itemShortName = serverInventory.itemShortName
        inventory.list_description = serverInventory.itemNotes
        inventory.name = serverInventory.itemName
        inventory.openItem = serverInventory.openItem
        inventory.price = serverInventory.price
        inventory.printItem = serverInventory.printItem
        inventory.tareWeight = serverInventory.tareWeight
        inventory.usesWeightScale = serverInventory.usesWeightScale
        inventory.weighted = serverInventory.weighted
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