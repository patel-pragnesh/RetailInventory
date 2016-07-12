//
//  Modifiers.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/12/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct ModifiersResponse {
    var active: Bool?
    var cost: Double?
    var id: Int?
    var locationId: Int?
    var name: String?
    var price: Double?
    var modifierSetMap: [ModifierResponse]?
}