//
//  TableView.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/14/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

extension UITableView {
    
    func backgroundForTableCell(at indexPath: NSIndexPath) -> UIImageView {
        let numberOfRows = self.numberOfRowsInSection(indexPath.section)
        
        if numberOfRows == 1 {
            return UIImageView(image: UIImage(named: "singleCell"))
        }        
        switch indexPath.row {
        case 0:
            return UIImageView(image: UIImage(named: "cellTop"))
        case numberOfRows - 1:
            return UIImageView(image: UIImage(named: "cellBottom"))
        default:
            return UIImageView(image: UIImage(named: "cellMiddleBottom"))
        }
    }
}
