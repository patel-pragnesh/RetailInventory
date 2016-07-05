//
//  AdjustStockLevelsMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class AdjustStockLevelsData: EntityMethods<AdjustStockLevels> {
    
    init() {
        let adjustStockLevels = AdjustStockLevels.MR_findAllSortedBy("adjustId", ascending: true) as! [AdjustStockLevels]
        super.init(array: adjustStockLevels)
    }
    
    func addObject() -> AdjustStockLevels {
        let newAdjustStockLevels = AdjustStockLevels.MR_createEntity()!
        array.append(newAdjustStockLevels)
        return newAdjustStockLevels
    }
    
    func removeObject(adjustStockLevels: AdjustStockLevels) {
        adjustStockLevels.MR_deleteEntity()
    }
    
    func editObject(old: AdjustStockLevels, new: AdjustStockLevels) -> Bool {
        let index = array.indexOf(old)
        if index != nil {
            array[index!] = new
            return true
        } else {
            return false
        }
    }
}