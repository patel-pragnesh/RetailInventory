//
//  StoreSetup.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/14/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import UIKit

class StoreSetup {
    var title: String!
    var info: String!
    var image: UIImage!
    var hiddenSwitch: Bool!
    var hiddenArrow: Bool!
    
    init (title: String, info: String?, image: UIImage?, hiddenSwitch: Bool, hiddenArrow: Bool) {
        self.title = title
        self.hiddenSwitch = hiddenSwitch
        self.hiddenArrow = hiddenArrow
        self.info = info
        self.image = image
    }
}