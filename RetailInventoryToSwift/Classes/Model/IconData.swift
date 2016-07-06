//
//  IconData.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class IconData {
    var count: Int! {
        get {
            return arrayIcons.count
        }
    }
    var arrayIcons = [Character]()
    let startCode = 61440
    let endCode = 61568
    let anonymusIcons = [61455, 61471, 61472, 61503, 61519, 61535, 61551, 61567]
    
    init() {
        fillIcons()
    }
    
    func fillIcons() {
        for char in startCode ... endCode {
            if !anonymusIcons.contains(char) { arrayIcons.append(Character(UnicodeScalar(char))) }
        }
    }
    
    func itemForIndex(index: Int) -> Character? {
        if index < self.count && index >= 0 { return arrayIcons[index] }
        return nil
    }
}
