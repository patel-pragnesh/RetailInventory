//
//  AppliedTaxesViewController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class AppliedTaxesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedTaxes: [Tax]!
    var taxes = TaxMethods()

    func isSelectedItem(selectionItem: Tax) -> Bool {
            if selectedTaxes.count > 0 {
                for selectetItem in selectedTaxes {
                    if selectetItem === selectionItem {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    // MARK: - tableView DataSourse
    
    extension AppliedTaxesViewController: UITableViewDataSource {
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return taxes.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(SelectDetailCell.cellIdentifier, forIndexPath: indexPath) as! SelectDetailCell
            cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
            cell.selectionItem = taxes.getObjectByIndex(indexPath.row)
            cell.isSelected = isSelectedItem(taxes.getObjectByIndex(indexPath.row))
            
            return cell
        }
}