//
//  IconData.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class IconData {
    enum TypeIcons: Int {
        case hospitality = 0, retail
    }
    
    var сount: Int! {
        switch sourceType {
        case .hospitality:
            return hospitalityIcons.count
        case .retail:
            return retailIcons.count
        }
    }
    private var sourceType: TypeIcons = .hospitality
    
    var source: Int! {
        didSet {
            sourceType = TypeIcons(rawValue: source)!
        }
    }

    var hospitalityIcons = [Character]()
    var retailIcons = [Character]()
    
    let startCodeHospitality = 61440
    let endCodeHospitality = 61491
    
    let startCodeRetail = 61492
    let endCodeRetail = 61568
    
    let emptyCode = 61569
    let anonymusIcons = [61455, 61471, 61472, 61503, 61519, 61535, 61551, 61567]
    
    init() {
        fillIcons()
    }
    
    func fillIcons() {
        hospitalityIcons.append(Character(UnicodeScalar(emptyCode)))
        retailIcons.append(Character(UnicodeScalar(emptyCode)))
        
        for char in startCodeHospitality ... endCodeHospitality {
            if !anonymusIcons.contains(char) {
                hospitalityIcons.append(Character(UnicodeScalar(char)))
            }
        }
        for char in startCodeRetail ... endCodeRetail {
            if !anonymusIcons.contains(char) {
                retailIcons.append(Character(UnicodeScalar(char)))
            }
        }
    }
    
    func itemForIndex(index: Int) -> Character {
        switch sourceType {
        case .hospitality:
            return hospitalityIcons[index]
        case .retail:
            return retailIcons[index]
        }
    }
}
