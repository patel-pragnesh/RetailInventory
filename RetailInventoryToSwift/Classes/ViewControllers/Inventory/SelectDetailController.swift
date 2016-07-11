//
//  SelectDetailController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/22/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol SelectDetailDelegate: class {
    func updateDepartment(department: Department?)
    func updateTax(tax:Tax?)
    func updateVendor(vendor: Vendor?)
    func updateTag(tag: Tag?)
    func updateSet(set: Set?)
}

enum SelectionType: Int {
    case vendor = 0, department, tax, tag, set
}

class SelectDetailController: BaseViewController {

    weak var delegate: SelectDetailDelegate?
    
    var department: Department?
    var vendor: Vendor?
    var tax: Tax?
    var tag: Tag?
    var set: Set?
    var selectionType: SelectionType!
    var selectionArray: [AnyObject]!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:

    override func viewDidLoad() {
        selectWorkingType()
        configTitles()
        super.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        switch selectionType! {
        case .department:
            self.navigationItem.title = "selectDetail.selectDepartment".localized
        case .tax:
            self.navigationItem.title = "selectDetail.selectTax".localized
        case .vendor:
             self.navigationItem.title = "selectDetail.selectVendor".localized
        case .tag:
            self.navigationItem.title = "selectDetail.selectTag".localized
        case .set:
            self.navigationItem.title = "selectDetail.selectSet".localized
        }
    }
   
    private func selectWorkingType() {
        switch selectionType! {
        case .department:
            selectionArray = DepartmentData().getArray()
        case .tax:
            selectionArray = TaxData().getArray()
        case .vendor:
            selectionArray = VendorData().getArray()
        case .tag:
            selectionArray = TagData().getArray()
        case .set:
            selectionArray = SetData().getArray()
        }
    }
    
    private func updateItem(item: AnyObject?) {
        switch selectionType! {
        case .department:
            department = item as? Department
            updateDepartment(department)
        case .tax:
            tax = item as? Tax
            updateTax(tax)
        case .vendor:
            vendor = item as? Vendor
            updateVendor(vendor)
        case .tag:
            tag = item as? Tag
            updateTag(tag)
        case .set:
            set = item as? Set
            updateSet(set)
        }
    }
    
    private func selectedItem() -> AnyObject? {
        switch SelectionType(rawValue: selectionType.rawValue)! {
        case .department:
            return department
        case .tax:
            return tax
        case .vendor:
            return vendor
        case .set:
            return set
        case .tag:
            return tag
        }
    }
}

// MARK: - UITableViewDataSource

extension SelectDetailController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SelectDetailCell.cellIdentifier, forIndexPath: indexPath) as! SelectDetailCell
        cell.backgroundView = tableView.backgroundForTableCell(at: indexPath)
        cell.itemForSelect = selectionArray[indexPath.row]
        cell.isSelected = cell.itemForSelect === selectedItem()
                
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectDetailController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectDetailCell
        cell.isSelected! ? updateItem(nil) : updateItem(selectionArray[indexPath.row])
        tableView.reloadData()
   }
}

// MARK: - SelectDetailDelegate

extension SelectDetailController: SelectDetailDelegate {
    
    func updateDepartment(department: Department?) {
        delegate!.updateDepartment(department)
    }
    
    func updateTax(tax:Tax?) {
        delegate!.updateTax(tax)
    }
    
    func updateVendor(vendor: Vendor?) {
        delegate!.updateVendor(vendor)
    }
    
    func updateTag(tag: Tag?) {
        delegate!.updateTag(tag)
    }
    
    func updateSet(set: Set?) {
        delegate!.updateSet(set)
    }
}

