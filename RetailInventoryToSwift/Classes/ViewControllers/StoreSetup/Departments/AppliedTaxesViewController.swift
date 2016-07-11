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
    var taxes = TaxData()
    var delegate: SelectedTaxesDelegate?
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitles()
    }
    
    override func viewDidDisappear(animated: Bool) {
        delegate?.selectedTaxes(selectedTaxes)
    }
    
    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "selectDetail.selectTax".localized
    }

    private func isSelectedItem(tax: Tax) -> Bool {
        if selectedTaxes.count > 0 {
            for selectedItem in selectedTaxes {
                if selectedItem.id === tax.id {
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
            cell.itemForSelect = taxes.getObjectByIndex(indexPath.row)
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