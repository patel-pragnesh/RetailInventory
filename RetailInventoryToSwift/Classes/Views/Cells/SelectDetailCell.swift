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
    
    var selectionItem: AnyObject! {
        didSet {
            if let selectedDepartment = selectionItem as? Department {
                selectionItemLabel.text = selectedDepartment.name
            }
            if let selectedVendor = selectionItem as? Vendor {
                selectionItemLabel.text = selectedVendor.name
            }
            if let selectedTax = selectionItem as? Tax {
                selectionItemLabel.text = selectedTax.taxName
            }
            if let selectedInventory = selectionItem as? InventoryList {
                selectionItemLabel.text = selectedInventory.barcode
            }
        }
    }
}
