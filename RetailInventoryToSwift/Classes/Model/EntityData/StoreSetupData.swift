//
//  StoreSetupMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/14/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class StoreSetupData: EntityMethods<StoreSetup>{
    
    let segueCellsArray = [MyConstant.segueFromDepartments, MyConstant.segueFromVendors, MyConstant.segueFromTaxes]
    
    init() {
        super.init(array: StoreSetupData().getData())
    }
    
    func enumCells(index: Int) -> StoreSetupData.numCells{
        return StoreSetupData.numCells(rawValue: index)!
    }
    
    func segueName(enumCell: StoreSetupData.numCells) -> String? {
        if enumCell.rawValue < segueCellsArray.count {
            return segueCellsArray[enumCell.rawValue]
        } else {
            return nil
        }
    }
}