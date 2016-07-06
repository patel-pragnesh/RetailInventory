//
//  DepartmentResponse.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/1/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

struct DepartmentResponse {
    var name: String
    var id: Int
    var active: Bool
    var itemsAreEBT: Bool
    var glyph: String
    var taxesId: [Int]?
}