//
//  SelectDescriptionCell.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/28/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class SelectDescriptionCell: BaseCell {
    static let cellIdentifier = String(SelectDescriptionCell)

    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionText: String! {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
}
