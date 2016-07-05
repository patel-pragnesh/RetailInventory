//
//  String.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/15/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}
