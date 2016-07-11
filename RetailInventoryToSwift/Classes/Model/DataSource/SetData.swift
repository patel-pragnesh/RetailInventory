//
//  SetData.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/11/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class SetData: EntityMethods<Set> {
    
    init() {
        let sets = DataManager.fetchAllSet()
        super.init(array: sets)
    }
    
    static func addSet(active: Bool?, id: Int?, manyPer: Bool?, max: Bool?, name: String?) -> Set {
        return DataManager.addSet(id, active: active, manyPer: manyPer, max: max, name: name)
    }
    
    static func addSetsFromResponse(setsResponse: [SetResponse]) {
        let localSets = DataManager.fetchAllSet()
        
        for set in setsResponse {
            var isConsist = false
            for locSet in localSets {
                if locSet.id == set.id {
                    updateSet(locSet, fromResponse: set)
                    isConsist = true
                    break
                }
            }
            if !isConsist {
                addSet(set.active, id: set.id, manyPer: set.manyPer, max: set.max, name: set.name)
            }            
        }
    }
    
    static func updateSet( locSet: Set, fromResponse newSet: SetResponse) {
        locSet.active = newSet.active
        locSet.manyPer = newSet.manyPer
        locSet.max = newSet.max
        locSet.name = newSet.name
    }
}