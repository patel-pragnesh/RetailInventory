//
//  SelectDetailCell.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/23/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class SelectDetailCell: BaseCell {
    static let cellIdentifier = String(SelectDetailCell)
    
    @IBOutlet private weak var selectionItemLabel: UILabel!
    @IBOutlet private weak var checkMarkImage: UIImageView!
    
    var isSelected: Bool! {
        didSet {
            checkMarkImage.hidden = !isSelected
        }
    }
    
    var itemForSelect: AnyObject! {
        didSet {
            if let selectedDepartment = itemForSelect as? Department {
                selectionItemLabel.text = selectedDepartment.name
            }
            if let selectedVendor = itemForSelect as? Vendor {
                selectionItemLabel.text = selectedVendor.name
            }
            if let selectedTax = itemForSelect as? Tax {
                selectionItemLabel.text = selectedTax.taxName
            }
            if let selectedInventory = itemForSelect as? InventoryList {
                selectionItemLabel.text = selectedInventory.name
            }
        }
    }
}
