//
//  InventoryController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/13/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol StartScanBarcode: class {
    func startScan()
}

protocol ScanNewBarCodeDelegate: class  {
    func scanNew(barcode: String)
    func editExisting(barcode: String)
}

enum SortButton: Int {
    case all = 0, departments, vendor
}

class InventoryController: BaseViewController {
    
    var inventorys = InventoryListData()
    var sortedBy: SortButton = .all
    var selectIndexPath: NSIndexPath!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noItemsScannedLabel: UILabel!
    @IBOutlet private weak var sendToLabel: UILabel!
    @IBOutlet private weak var sortAllButton: UIButton!
    @IBOutlet private weak var sortDepartmentsButton: UIButton!
    @IBOutlet private weak var sortVendorButton: UIButton!
    @IBOutlet private weak var checkBoxButton: UIButton!
    @IBOutlet private weak var submitInventoryButton: UIButton!
    @IBOutlet private var collectionSortButtons: [UIButton]!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTitles()
        rightBarItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        inventorys.refresh()
        inventorys.sort(sortedBy)
        tableView.reloadData()
    }

    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "inventory.title".localized
        noItemsScannedLabel.text = "inventory.noItemsScannedLabel".localized
        sortAllButton.setTitle("inventory.allButton".localized, forState: .Normal)
        sortDepartmentsButton.setTitle("inventory.departmentsButton".localized, forState: .Normal)
        sortVendorButton.setTitle("inventory.vendorButton".localized, forState: .Normal)
        submitInventoryButton.setTitle("inventory.submitMyInventory".localized, forState: .Normal)
        sendToLabel.text = "inventory.sendToLabel".localized
    }
    
    private func rightBarItems() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.scan))
        barItems.append(getBarButtonView(.question))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    private func sortTableViewContent(sort: SortButton) {
        if sort == sortedBy { return }
        
        sortedBy = sort
        inventorys.sort(sortedBy)               
        tableView.reloadData()
    }
    
    private func selectedSortButtons(button: UIButton) {
        for sortButton in collectionSortButtons {
            sortButton.selected = false
        }
        button.selected = true
    }
    
    // MARK: - PrepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MyConstant.segueScan {
            let upcoming = segue.destinationViewController as! ScanController
            upcoming.delegate = self
        }
        if segue.identifier == MyConstant.segueInventaryDetail {
            let upcoming = segue.destinationViewController as! InventoryDetailController
            upcoming.barcode = inventorys.getObjectByIndex(selectIndexPath.row).barcode
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onSortButtonTouch(sender: UIButton) {
        selectedSortButtons(sender)
        sortTableViewContent(SortButton(rawValue: sender.tag)!)
    }
    
    @IBAction func onSubmitTouch(sender: AnyObject) {
    
    }
    
    @IBAction func checkBoxButtonTouch(sender: AnyObject) {
        checkBoxButton.selected = !checkBoxButton.selected
    }
    
    // MARK: - Override  navigation bar action
    
    override func scanButtonTouch(button: UIButton) {
        self.performSegueWithIdentifier(MyConstant.segueScan, sender: self)
    }
}

// MARK: - UITableViewDataSource

extension InventoryController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noItemsScannedLabel.hidden = inventorys.count > 0
        return inventorys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InventoryCell.cellIdentifier, forIndexPath: indexPath) as! InventoryCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        cell.inventory = inventorys.getObjectByIndex(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title:"inventory.deleteTitle".localized, handler: {(actin, indexPath) -> Void in
            InventoryListData.removeInventory(self.inventorys.getObjectByIndex(indexPath.row))
            self.inventorys.refresh()
            tableView.reloadData()            
        })
        deleteAction.backgroundColor = UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }
}

// MARK: - UITableViewDelegate

extension InventoryController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectIndexPath = indexPath
        performSegueWithIdentifier(MyConstant.segueInventaryDetail, sender: self)
    }
}

// MARK: - ScanNewBarCodeDelegate

extension InventoryController: ScanNewBarCodeDelegate {
    
    func scanNew(barcode: String) {
        let newInventory = InventoryListData.addInventory(barcode)
        inventorys.refresh()
        selectIndexPath = NSIndexPath(forRow: inventorys.getIndex(newInventory)!, inSection: 0)
        performSegueWithIdentifier(MyConstant.segueInventaryDetail, sender: self)
        tableView.reloadData()
    }
    
    func editExisting(barcode: String) {
        if inventorys.count != 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(inventorys.count)))
            selectIndexPath = NSIndexPath(forRow: randomIndex, inSection: 0)
            InventoryListData.editInventory(InventoryListField.barcode, at: inventorys.getObjectByIndex(randomIndex), value: barcode)
            performSegueWithIdentifier(MyConstant.segueInventaryDetail, sender: self)
        }
    }
}