//
//  UserDefault.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/1/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class UserStorage {
    
    // Key for Defaults
    
    static private let keyForLookUP = "lookUpItemDescirption"
    static private let keyForCostTracking = "costTracking"
    static private let defaults = NSUserDefaults.standardUserDefaults()

    static func getLookUpDescription() -> Bool {
        return defaults.boolForKey(keyForLookUP)
    }
    
    static func setLookUpDescription(newValue: Bool) {
        defaults.setBool(newValue, forKey: keyForLookUP)
    }
    
    static func getCostTracking() -> Bool {
        return defaults.boolForKey(keyForCostTracking)
    }
    
    static func setCostTracking(newValue: Bool) {
        defaults.setBool(newValue, forKey: keyForCostTracking)
    }
    
    static func clearData() {
        defaults.removeObjectForKey(keyForLookUP)
        defaults.removeObjectForKey(keyForCostTracking)
    }
}
