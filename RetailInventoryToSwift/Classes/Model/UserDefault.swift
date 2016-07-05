//
//  UserDefault.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/1/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class UserDefault {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    private var _lookUpItemDescription: Bool!
    var lookUpItemDescription: Bool {
        get {
            return defaults.boolForKey(MyConstant.keyForLookUP)
        }
        set {
            _lookUpItemDescription = newValue
            defaults.setBool(_lookUpItemDescription, forKey: MyConstant.keyForLookUP)
        }
    }
    private var _costTracking: Bool!
    var costTracking: Bool {
        get {
            return defaults.boolForKey(MyConstant.keyForCostTracking)
        }
        
        set {
            _costTracking = newValue
            defaults.setBool(_costTracking, forKey: MyConstant.keyForCostTracking)
        }
    }
}
