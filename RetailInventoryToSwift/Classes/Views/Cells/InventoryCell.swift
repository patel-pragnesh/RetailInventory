//
//  InventoryCell.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/13/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class InventoryCell: BaseCell {
    
    static let cellIdentifier = String(InventoryCell)
    
    @IBOutlet private weak var barCode: UILabel!
    @IBOutlet private weak var descriptions: UILabel!
    
    var inventory: InventoryList! {
        didSet {
            barCode.text = inventory.name
            if inventory.list_description != nil {
                descriptions.hidden = false
                descriptions.text = inventory.list_description
            } else {
                descriptions.hidden = true
            }
        }
    }
}
