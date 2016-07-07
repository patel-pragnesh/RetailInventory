//
//  AppliedTaxesViewController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol SelectedTaxesDelegate: class {
    
    func selectedTaxes(selectedTaxes: [Tax])
}

class AppliedTaxesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedTaxes: [Tax]!
    var taxes = TaxMethods()
    var delegate: SelectedTaxesDelegate?
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles()
    }
    
    override func viewDidDisappear(animated: Bool) {
        delegate?.selectedTaxes(selectedTaxes)
    }
    
    // MARK: - Private
    
    private func titles() {
        self.navigationItem.title = "selectDetail.selectTax".localized
    }

    private func isSelectedItem(selectionItem: Tax) -> Bool {
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

// MARK: - UItableViewDataSourse

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

// MARK: - UITableViewDelegate

extension AppliedTaxesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectDetailCell
        if cell.isSelected! {
            selectedTaxes.removeAtIndex(selectedTaxes.indexOf(taxes.getObjectByIndex(indexPath.row))!)
        } else {
            selectedTaxes.append(taxes.getObjectByIndex(indexPath.row))
        }
        tableView.reloadData()
    }
}