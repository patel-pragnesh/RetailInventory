//
//  AppliedItemsViewController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class AppliedItemsViewController: BaseViewController {
    
    var selectedItems: [InventoryList]!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitles()
    }
    
    private func configTitles() {
        self.navigationItem.title = "selectDetail.selectInventory".localized
    }
}

// MARK: - tableView DataSourse

extension AppliedItemsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SelectDetailCell.cellIdentifier, forIndexPath: indexPath) as! SelectDetailCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        cell.itemForSelect = selectedItems[indexPath.row]

        
        return cell
    }
}
