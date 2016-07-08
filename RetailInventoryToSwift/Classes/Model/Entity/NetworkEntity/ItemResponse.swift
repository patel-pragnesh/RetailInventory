//
//  ItemResponse.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/8/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct ItemResponse {
    var departmentId: Int?
    var itemName: String
    var itemNotes: String
    var price: String?
    var cost: String?
    var id: Int
    var barcode: String?
}