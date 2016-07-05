//
//  InventoryListMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class InventoryListData: EntityMethods<InventoryList> {
    
    init() {
        let inventorys = DataManager.store.fetchAllInventoryList()
        super.init(array: inventorys)
    }
    
    func newInventory() -> InventoryList {
        return DataManager.store.newInventoryList()
    }
    
    func addInventory(barcode: String?,
                      cost: String?,
                      list_description: String?,
                      listTaxes: NSObject?,
                      merchantID: String?,
                      needUpdate: NSNumber?,
                      price: String?,
                      listDepartment: Department?,
                      listVendor: Vendor?,
                      listTax: Tax?,
                      adjustStockLevels: AdjustStockLevels?) {
         DataManager.store.addInventoryList(barcode, cost: cost,list_description: list_description, listTaxes: listTaxes, merchantID: merchantID, needUpdate: needUpdate, price: price, listDepartment: listDepartment, listVendor: listVendor, listTax: listTax, adjustStockLevels: adjustStockLevels)
    }
        
    func removeInventory(inventory: InventoryList) -> Bool {
        return DataManager.store.deleteInventoryList(inventory)
    }
    
    override func refresh() {
        array = DataManager.store.fetchAllInventoryList()
    }    
}