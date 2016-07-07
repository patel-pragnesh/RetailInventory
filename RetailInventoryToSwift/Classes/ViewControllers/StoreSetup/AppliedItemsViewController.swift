//
//  AppliedItemsViewController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class AppliedItemsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedItems: [InventoryList]!
    var invetorys = InventoryListMethods()
    
    // MARK: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles()
    }
    
    private func titles() {
        self.navigationItem.title = "selectDetail.selectInventory".localized
    }
    
    func isSelectedItem(selectionItem: InventoryList) -> Bool {
        if selectedItems.count > 0 {
            for selectetItem in selectedItems {
                if selectetItem === selectionItem {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: - tableView DataSourse

extension AppliedItemsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invetorys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SelectDetailCell.cellIdentifier, forIndexPath: indexPath) as! SelectDetailCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        cell.selectionItem = invetorys.getObjectByIndex(indexPath.row)
        cell.isSelected = isSelectedItem(invetorys.getObjectByIndex(indexPath.row))
        
        return cell
    }
}
