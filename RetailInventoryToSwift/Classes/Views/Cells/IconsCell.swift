//
//  IconsCell.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class IconsCell: UICollectionViewCell {
    
    static let cellIdentifier = String(IconsCell)
    
    @IBOutlet private weak var icon: UILabel!
    
    var title: String! {
        didSet {
            self.icon.text = title
        }
    }
}
