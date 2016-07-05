//
//  DepartmentAndVendorCell.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class DepartmentAndVendorCell: BaseCell {
    
    static let cellIdentifier = String(DepartmentAndVendorCell)
    
    @IBOutlet private weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var department: Department! {
        didSet {
            if department.name != nil {
                self.titleLabel.text = department.name
            } else {
                self.titleLabel.text = ""
            }
            
        }
    }
    
    var vendor: Vendor! {
        didSet {
            if vendor.name != nil {
                self.titleLabel.text = vendor.name
            } else {
                self.titleLabel.text = ""
            }
            
        }
    }
}