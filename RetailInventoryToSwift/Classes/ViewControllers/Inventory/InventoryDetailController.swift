//
//  InventoryDetailController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/17/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit
import Alamofire

class InventoryDetailController: BaseViewController {
    
    var barcode: String!
    private var listDescriptions: [String]?    
    private var inventory: InventoryList!
    private let detailNames = InventoryDetailMethods()
    private var editableRow: Int!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var networkActivity: UIActivityIndicatorView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTitles()
        subscribeKeyboardNotification()
        loadInventory()
        downloadDescriptionsIfAllowed()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "inventoryDetail.title".localized
        scanButton.setTitle("inventoryDetail.scanNewItem".localized, forState: .Normal)
    }
    
    private func loadInventory() {
        inventory = InventoryListMethods.getInventoryByBarcode(barcode)
        if inventory.list_description != nil {
            networkActivity.hidden = true
        }
    }
    
    // MARK: - Animation scroll tableView
    
    func animateScrollTableView(indexPath: NSIndexPath, animated: Bool) {
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: animated)
    }
    
    
    // MARK: - Override
    
    override func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = keyboardFrameInfo(notification)
        var contentInsets = UIEdgeInsetsZero
        contentInsets.bottom = keyboardFrame.height
        tableView.contentInset = contentInsets
        
        if editableRow == nil { return }
        animateScrollTableView(NSIndexPath(forRow: editableRow, inSection: 0), animated: false)
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        tableView.contentInset = contentInsets
    }
    
    // MARK: - PrepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MyConstant.segueScan {
            let upcoming = segue.destinationViewController as! ScanController
            upcoming.delegate = self
            return
        }
        
        if segue.identifier == MyConstant.segueSelectDescription {
            let upcoming = segue.destinationViewController as! SelectDescriptionController
            upcoming.descriptions = listDescriptions
            upcoming.delegate = self
            return
        }
        
        let upcoming = segue.destinationViewController as! SelectDetailController
        upcoming.delegate = self
        if segue.identifier == MyConstant.segueSelectVendors {
            upcoming.vendor = inventory.listVendor
            upcoming.selectionType = SelectionType.vendor
        }
        if segue.identifier == MyConstant.segueSelectDepartments {
            upcoming.department = inventory.listDepartment
            upcoming.selectionType = SelectionType.department
        }
        if segue.identifier == MyConstant.segueSelectTaxes {
            upcoming.tax = inventory.listTax
            upcoming.selectionType = SelectionType.tax
        }
    }
    
    // MARK: - ChangeResponder
    
    func changeResponder(tag: Int, changeToUp: Bool) {
        var index = tag
        if changeToUp {
            index += 1
            if index == detailNames.count {
                index = 0
            }
        } else {
            index -= 1
            if index < 0 {
                index = detailNames.count - 1
            }
        }
        animateScrollTableView(NSIndexPath(forRow: index, inSection: 0), animated: false)
        let newCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! InventoryDetailCell
        if newCell.editable {
            newCell.becomeResponder()
        } else {
            changeResponder(index, changeToUp: changeToUp)
        }
    }
    
    // MARK: - Download descriptions
    
    func downloadDescriptionsIfAllowed() {
        if UserStorage.getLookUpDescription() {
            downloadDescriptions(barcode)
        } else {
            networkActivity.hidden = true
        }
    }
    
    func downloadDescriptions(barcode: String) {
        if inventory.list_description == nil {
            networkActivity.hidden = false
            networkActivity.startAnimating()
            NetworkLoader.downloadDescription(barcode,
                                                progress: { percent in
                                                    self.networkActivity.stopAnimating()
                                                    self.networkActivity.hidden = true
                                                },
                                                completion: { descriptions in
                                                    self.completition(descriptions)
                                                })
        }
    }
    
    func completition(descriptions: [String]) {
        self.listDescriptions = descriptions
        if listDescriptions?.count > 0 {
            performSegueWithIdentifier(MyConstant.segueSelectDescription, sender: self)
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func scanNewButtonTouch(sender: AnyObject) {
        performSegueWithIdentifier(MyConstant.segueScan, sender: self)
    }    
}

// MARK: - UITableViewDataSource

extension InventoryDetailController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(InventoryDetailCell.cellIdentifier, forIndexPath: indexPath) as! InventoryDetailCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        cell.cellContents = (detailNames.getObjectByIndex(indexPath.row), indexPath.row, inventory)
        cell.delegate = self
        cell.tag = indexPath.row
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InventoryDetailController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let segueName = InventoryDetailMethods.segueName(indexPath.row) {
            performSegueWithIdentifier(segueName, sender: self)
        }
    }
}

// MARK: - ToolBarControlsDelegate

extension InventoryDetailController: ToolBarControlsDelegate {
    
    func nextButtonTouch(cellTag: Int) {
        changeResponder(cellTag ,changeToUp: true)
    }
    
    func prevButtonTouch(cellTag: Int) {
        changeResponder(cellTag ,changeToUp: false)
    }
    
    func doneButtonTouch(cellTag: Int) {
        self.view.endEditing(true)
        animateScrollTableView(NSIndexPath(forRow: 0, inSection: 0), animated: false)
    }
    
    func textFieldEndEditing(text: String?, cellTag: Int) {
        if text != "" {
             InventoryListMethods.editInventory(InventoryListField(rawValue: InventoryDetailMethods.fieldNameForDetail(DetailName(rawValue: cellTag)!))!, at: inventory, value: text!)
        } else {
            InventoryListMethods.editInventory(InventoryListField(rawValue: InventoryDetailMethods.fieldNameForDetail(DetailName(rawValue: cellTag)!))!, at: inventory, value: nil)
        }
    }
    
    func textFieldBeginEditing(cellTag: Int) {
        editableRow = cellTag
    }
}

// MARK: - SelectDetailDelegate

extension InventoryDetailController: SelectDetailDelegate {
    
    func updateDepartment(department: Department?) {
        InventoryListMethods.editInventory(InventoryListField.listDepartment, at: inventory, value: department)
    }
    
    func updateTax(tax: Tax?) {
        InventoryListMethods.editInventory(InventoryListField.listTax, at: inventory, value: tax)
    }
    
    func updateVendor(vendor: Vendor?) {
        InventoryListMethods.editInventory(InventoryListField.listVendor, at: inventory, value: vendor)
    }
}

// MARK: - ScanNewBarCodeDelegate

extension InventoryDetailController: ScanNewBarCodeDelegate {
    
    func scanNew(barcode: String) {
        InventoryListMethods.addInventory(barcode)
        self.barcode = barcode
        loadInventory()
        downloadDescriptionsIfAllowed()
    }
    
    func editExisting(barcode: String) {
        InventoryListMethods.editInventory(InventoryListField.barcode, at: inventory, value: barcode)
        self.barcode = barcode
        downloadDescriptionsIfAllowed()
    }
}

// MARK: - SelectDescription

extension InventoryDetailController: SelectDescription {
    
    func selectDescription(description: String) {
        InventoryListMethods.editInventory(InventoryListField.descriptopn, at: inventory, value: description)        
    }
}