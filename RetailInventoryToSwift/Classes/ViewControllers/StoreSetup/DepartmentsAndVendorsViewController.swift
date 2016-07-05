//
//  DepartmentsAndVendorsViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

enum ControllerType: Int {
    case department = 0, vendor
}

class DepartmentsAndVendorsViewController: BaseViewController  {
    
    var departments: DepartmentMethods?
    var vendors: VendorMethods?
    
    var controllerType: ControllerType!
    var selectedRow: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch controllerType! {
        case .department:
            departments = DepartmentMethods()
        case .vendor:
            vendors = VendorMethods()
        }
        imageForButton()
        titleView()
    }
    
    override func viewWillAppear(animated: Bool) {
        switch controllerType! {
        case .department:
            departments!.refresh()
            tableView.reloadData()
        case .vendor:
            vendors!.refresh()
            tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        switch controllerType! {
        case .department:
            DepartmentMethods.save()
        case .vendor:
            VendorMethods.save()
        }
    }
    
    // MARK: - title

    func titleView() {
        switch controllerType! {
        case .department:
            self.navigationItem.title = "depart.title".localized
        case .vendor:
            self.navigationItem.title = "vendors.title".localized
        }
    }
    
    // MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case MyConstant.segueAddListFromCellDepartment:
            let secondViewController: AddDepartmentViewController = segue.destinationViewController as! AddDepartmentViewController
            secondViewController.editableDepartment = departments!.getObjectByIndex(selectedRow!)
            secondViewController.typeWorking = ControllerTypeWorking.edit
            secondViewController.delegateAddDepartmentViewController = self
        
        case MyConstant.segueAddListFromCellVendor:
            let secondViewController: AddVendorViewController = segue.destinationViewController as! AddVendorViewController
            secondViewController.editableVendor = vendors!.getObjectByIndex(selectedRow!)
            secondViewController.typeWorking = ControllerTypeWorking.edit
            secondViewController.delegateAddVendorViewControllerDelegate = self            
        
        case MyConstant.segueAddListFromButtonDepartment:
            let secondViewController: AddDepartmentViewController = segue.destinationViewController as! AddDepartmentViewController
            secondViewController.editableDepartment = nil
            secondViewController.typeWorking = ControllerTypeWorking.add
            secondViewController.delegateAddDepartmentViewController = self
        
        case MyConstant.segueAddListFromButtonVendor:
            let secondViewController: AddVendorViewController = segue.destinationViewController as! AddVendorViewController
            secondViewController.editableVendor = nil
            secondViewController.typeWorking = ControllerTypeWorking.add
            secondViewController.delegateAddVendorViewControllerDelegate = self
        default:
            break
        }
    }
    
    // MARK: - navigationBarButton
    
    func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.add))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    override func addButtonTouch(button: UIButton) {
        switch controllerType! {
        case .department:
            self.performSegueWithIdentifier(MyConstant.segueAddListFromButtonDepartment, sender: self)
        case .vendor:
            self.performSegueWithIdentifier(MyConstant.segueAddListFromButtonVendor, sender: self)
        }
    }
}

// MARK: - tableView Data Sourse

extension DepartmentsAndVendorsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch controllerType! {
        case .department:
            return departments!.count
        case .vendor:
            return vendors!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DepartmentAndVendorCell.cellIdentifier, forIndexPath: indexPath) as! DepartmentAndVendorCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        tableView.rowHeight = cell.heightCell
        
        switch controllerType! {
        case .department:
            cell.department = departments!.getObjectByIndex(indexPath.row)
        case .vendor:
            cell.vendor = vendors!.getObjectByIndex(indexPath.row)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title:"inventory.deleteTitle".localized, handler: {(actin, indexPath) -> Void in
            switch self.controllerType! {
            case .department:
                self.departments!.removeDepartment(self.departments!.getObjectByIndex(indexPath.row))
                self.departments!.refresh()
            case .vendor:
                self.vendors!.removeVendor(self.vendors!.getObjectByIndex(indexPath.row))
                self.vendors!.refresh()
            }
            tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor(red: 255.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }
}

// MARK: - tableView Delegate

extension DepartmentsAndVendorsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        switch controllerType! {
        case .department:
            performSegueWithIdentifier(MyConstant.segueAddListFromCellDepartment, sender: self)
        case .vendor:
            performSegueWithIdentifier(MyConstant.segueAddListFromCellVendor, sender: self)
        }
    }
}

// MARK: - AddVendorViewControllerDelegate Methods

extension DepartmentsAndVendorsViewController: AddVendorViewControllerDelegate {
    
    func addVendorToBase(info: VendorTemplate) {
        vendors?.addFromTemplate(info)
    }

    func editVendorToBase(info: VendorTemplate) {
        vendors!.editFromTemplate(vendors!.getObjectByIndex(selectedRow), template: info)
    }
}

// MARK: - AddDepartmentViewControllerDelegate Methods

extension DepartmentsAndVendorsViewController: AddDepartmentViewControllerDelegate {
    
    func addDepartmentToBase(info: DepartmentTemplate) {
        departments!.addDepartmentFromTemplate(info)
    }
    
    func editDepartmentToBase(info: DepartmentTemplate) {
        departments!.editDepartmentWithTemplate(selectedRow, template: info)

    }
}