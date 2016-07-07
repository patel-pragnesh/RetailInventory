//
//  StoreSetupViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 06.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class StoreSetupViewController: BaseViewController {
    
    var storeSetupMethods: StoreSetupMethods!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitles()
        imageForButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        storeSetupMethods = StoreSetupMethods()
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        self.navigationItem.title = "storeSetup.title".localized
    }
    
    private func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.question))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    // MARK: - Alert
    
    func clearAlert() {
        let claerInventoryAlert = UIAlertController(title: "storeSetup.alertTitle".localized, message: "storeSetup.alertMessage".localized, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "storeSetup.alertCancel".localized, style: .Cancel) { (action:UIAlertAction!) in
            return
        }
        let clearAction = UIAlertAction(title: "storeSetup.alertClear".localized, style: .Default) {
            (action:UIAlertAction!) in
            InventoryListMethods.removeAll()
            self.storeSetupMethods = StoreSetupMethods()
            self.tableView.reloadData()
        }
        claerInventoryAlert.addAction(cancelAction)
        claerInventoryAlert.addAction(clearAction)
        self.presentViewController(claerInventoryAlert, animated: true, completion:nil)
    }
    
    // MARK: - Restore from backup
    
    func restore() {
        print("Restore")
    }
    
    // MARK: - Prepare for Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == MyConstant.segueDepartments {
            let secondViewController: DepartmentsAndVendorsViewController = segue.destinationViewController as! DepartmentsAndVendorsViewController
            secondViewController.controllerType = ControllerType.department
        }
        if segue.identifier! == MyConstant.segueVendors {
            let secondViewController: DepartmentsAndVendorsViewController = segue.destinationViewController as! DepartmentsAndVendorsViewController
            secondViewController.controllerType = ControllerType.vendor
        }
        
        if segue.identifier! == MyConstant.segueTaxes {
        }
    }
}

// MARK: - UITableViewDataSource

extension StoreSetupViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeSetupMethods.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCellWithIdentifier(StoreSetupCell.cellIdentifier, forIndexPath: indexPath) as! StoreSetupCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        tableView.rowHeight = cell.heightCell
        cell.cellContents = (indexPath.row, storeSetupMethods.getObjectByIndex(indexPath.row), UserStorage.getCostTracking(), UserStorage.getLookUpDescription())
        cell.delegateChangeSwitch = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate 

extension StoreSetupViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch StoreSetupMethods.enumCells(indexPath.row) {
        case .department:
            performSegueWithIdentifier(StoreSetupMethods.segueName(.department)!, sender: self)
        case .vendors:
            performSegueWithIdentifier(StoreSetupMethods.segueName(.vendors)!, sender: self)
        case .taxes:
            performSegueWithIdentifier(StoreSetupMethods.segueName(.taxes)!, sender: self)
        case .clear:
            clearAlert()
        case .restore:
            restore()
        default:
            break
        }
    }
}

// MARK: - ChangeSwitchStoreSetup

extension StoreSetupViewController: ChangeSwitchStoreSetupDelegate {
    
    func changeLookUpItem(newValue: Bool) {
        UserStorage.setLookUpDescription(newValue)
    }
    
    func changeCostTracking(newValue: Bool) {
        UserStorage.setCostTracking(newValue)
    }
}