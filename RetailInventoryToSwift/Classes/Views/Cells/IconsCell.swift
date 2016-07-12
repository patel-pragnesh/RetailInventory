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
    @IBOutlet private weak var borderView: UIView!
    
    var title: Character? {
        didSet {            
            icon.font = UIFont(name: "FontAwesome", size: MyConstant.iconSize)
            icon.text = String(title!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.layer.borderColor = UIColor.whiteColor().CGColor
        borderView.layer.borderWidth = 1
    }
}
