//
//  BaseMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/16/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class EntityMethods <Template> {
    
    var array: [Template]!
    
    var count: Int {
        get {
            return self.array.count
        }
    }
    
    init(array: [Template]) {
        self.array = array
    }
    
    func getArray() -> [Template] {
        return array
    }
    
    func getObjectByIndex(index: Int) -> Template {
        return array[index]
    }
        
    func refresh() {
    }
    
    static func save() {
        DataManager.saveContext()
    }
}