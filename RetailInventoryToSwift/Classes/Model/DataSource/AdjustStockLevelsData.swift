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
}