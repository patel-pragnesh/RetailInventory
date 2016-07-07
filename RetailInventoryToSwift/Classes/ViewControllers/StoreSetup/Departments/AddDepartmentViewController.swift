//
//  AddDepartmentViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol AddDepartmentViewControllerDelegate: class {
    func addDepartmentToBase(info: DepartmentTemplate)
    func editDepartmentToBase(info: DepartmentTemplate)
}

class AddDepartmentViewController: BaseViewController {
    
    weak var delegateAddDepartmentViewController: AddDepartmentViewControllerDelegate?
    
    var addDepartmentMethods = AddDepartmentsMethods()
    var editableDepartment: Department? {
        didSet {
            departmentTemplate.active = editableDepartment?.active
            departmentTemplate.icon = editableDepartment?.icon
            departmentTemplate.id = editableDepartment?.id
            departmentTemplate.itemsEbt = editableDepartment?.itemsEbt
            departmentTemplate.name = editableDepartment?.name
        }
    }
    var departmentTemplate = DepartmentTemplate()
    var typeWorking: ControllerTypeWorking!
    var editableRow: Int!
    var oldTaxes: [Tax]!
    var taxesForAdd: [Tax]?
    var taxesForRemove: [Tax]?
    var taxesNamesForCell: [String]?
    var needUpdateTaxes = false
    var countCompletedRequest = 0
    var countRequest = 0
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkActivity: UIActivityIndicatorView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageForButton()
        configTitles()
        subscribeKeyboardNotification()
        networkActivity.hidden = true
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

    
    // MARK: - prepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier ==  MyConstant.segueIcon {
            let iconViewController = segue.destinationViewController as! IconsViewController
            iconViewController.delegateIconViewController = self
        }
        if segue.identifier == MyConstant.segueAppliedItems {
            let upcoming = segue.destinationViewController as! AppliedItemsViewController
            upcoming.selectedItems = InventoryListMethods.itemsByDepartment(departmentTemplate.id!)
        }
        if segue.identifier == MyConstant.segueAppliedTaxes {
            let upcoming = segue.destinationViewController as! AppliedTaxesViewController
            oldTaxes = TaxMethods.taxesByDepartment(departmentTemplate.id!)
            upcoming.selectedTaxes = oldTaxes
            upcoming.delegate = self
        }
    }
    
    // MARK: - Private
    
    private func configTitles() {
        switch typeWorking! {
        case .add:
            self.navigationItem.title = "addDepart.titleAdd".localized
        case .edit:
            self.navigationItem.title = "addDepart.titleEdit".localized
        }
    }
    
    private func taxesForRequest(from oldTaxes: [Tax], and selectedTaxes: [Tax]) -> (newTaxes: [Tax], deleteTaxes: [Tax]) {
        var newTaxes = [Tax]()
        var deleteTaxes = [Tax]()
        
        for oldTax in oldTaxes {
            if selectedTaxes.indexOf(oldTax) == nil {
                deleteTaxes.append(oldTax)
            }
        }
        
        for selectedTax in selectedTaxes {
            if oldTaxes.indexOf(selectedTax) == nil {
                newTaxes.append(selectedTax)
            }
        }
        return (newTaxes, deleteTaxes)
    }
    
    // MARK: - navigationBarButton
    
    func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.save))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    override func saveButtonTouch(button: UIButton) {
        
        self.view.endEditing(true)
        
        SocketClient.checkConnection()
        
        networkActivity.hidden = false
        networkActivity.startAnimating()
        
        switch typeWorking! {
        case .add:
            countRequest += 1
            SocketClient.createDepartment(departmentTemplate, success: { department in
                                    self.delegateAddDepartmentViewController?.addDepartmentToBase(department)
                                    self.countCompletedRequest += 1
                                    self.stopAnimateNetworkActivity()
                                  },
                                  failure: { (code, message) in
                    self.errorAlert(code, at: message)
            })
        case .edit:
            countRequest += 1
            SocketClient.updateDepartment(departmentTemplate, success: { department in
                                                    if department.name != nil {
                                                        self.delegateAddDepartmentViewController?.editDepartmentToBase(department)
                                                        self.countCompletedRequest += 1
                                                        self.stopAnimateNetworkActivity()
                                                    }
                                                  },
                                                  failure: { (code, message) in
                                                    self.errorAlert(code, at: message)
                                                    self.networkActivity.hidden = true
                                                  })
        }
        sendTaxToServer()
    }
    
    func sendTaxToServer() {
        if taxesForAdd?.count > 0 {
            for tax in taxesForAdd! {
                countRequest += 1
                SocketClient.taxMapCreate(tax.id as! Int, DepartmentId: departmentTemplate.id as! Int,
                                      success: { department in
                                        TaxMethods.addDepartmentTo(tax, department: DepartmentMethods.departmentBy(department.id!))
                                        self.countCompletedRequest += 1
                                        self.stopAnimateNetworkActivity()
                                        
                                      },
                                      failure: { (code, message) in
                                        self.errorAlert(code, at: message)
                                    })
            }
        }
        if taxesForRemove?.count > 0 {
            for tax in taxesForRemove! {
                countRequest += 1
                SocketClient.taxMapCreate(tax.id as! Int, DepartmentId: departmentTemplate.id as! Int,
                                      success: { department in
                                        TaxMethods.removeDepartment(from: tax, department: DepartmentMethods.departmentBy(department.id!))
                                        self.countCompletedRequest += 1
                                        self.stopAnimateNetworkActivity()
                                      },
                                      failure: { (code, message) in
                                        self.errorAlert(code, at: message)
                                    })
            }
        }
    }
    
    // MARK: - ActivityIndicator control
    
    func stopAnimateNetworkActivity() {
        if countCompletedRequest == countRequest {
            networkActivity.stopAnimating()
            networkActivity.hidden = true
            countCompletedRequest = 0
            countRequest = 0
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - Alert
    
    func errorAlert(code: UInt, at message: String) {
        
        let errorAlert = UIAlertController(title:"\(code)", message: "\(message)", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "storeSetup.alertCancel".localized, style: .Default) { (action:UIAlertAction!) in
            return
        }
        errorAlert.addAction(cancelAction)
        self.presentViewController(errorAlert, animated: true, completion:nil)
    }
    
    // MARK: - Animation scroll tableView
    
    func animateScrollTableView(indexPath: NSIndexPath, animated: Bool) {
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: animated)
    }
    
    // MARK: - ChangeResponder
    
    func changeResponder(tag: Int, changeToUp: Bool) {
        var index = tag
        if changeToUp {
            index += 1
            if index == addDepartmentMethods.count {
                index = 0
            }
        } else {
            index -= 1
            if index < 0 {
                index = addDepartmentMethods.count - 1
            }
        }
        animateScrollTableView(NSIndexPath(forRow: index, inSection: 0), animated: false)
        let newCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! AddDepartmentCell
        if newCell.editable {
            newCell.becomeResponder()
        } else {
            changeResponder(index, changeToUp: changeToUp)
        }
    }
}

// MARK: - tableView Delegate

extension AddDepartmentViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nameSegue = addDepartmentMethods.segueName(addDepartmentMethods.enumCell(indexPath.row))
        if nameSegue != nil {
            performSegueWithIdentifier(nameSegue!, sender: self)
        }
    }
}

// MARK: - tableView DataSourse

extension AddDepartmentViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addDepartmentMethods.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddDepartmentCell.cellIdentifier, forIndexPath: indexPath) as! AddDepartmentCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        tableView.rowHeight = cell.heightCell
        
        cell.addDepartments = addDepartmentMethods.getObjectByIndex(indexPath.row)
        cell.delegateChangeSwitch = self
        cell.delegate = self
        cell.tag = indexPath.row
        cell.updateCell(addDepartmentMethods.parameterCell(addDepartmentMethods.enumCell(indexPath.row)),
                        infoCell: departmentTemplate,
                        identCell: addDepartmentMethods.enumCell(indexPath.row))
        return cell
    }
}

// MARK: - ToolBarControlsDelegate

extension AddDepartmentViewController: ToolBarControlsDelegate {
    
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
        switch DepartmentCell(rawValue: cellTag)! {
        case .name:
            if text != "" {
                departmentTemplate.name = text
            } else {
                errorAlert(0, at: "name must have value")
                tableView.reloadData()                
            }
        default:
            break
        }
    }
    
    func textFieldBeginEditing(cellTag: Int) {
        editableRow = cellTag
    }
}

// MARK: - AddDepartmentCellDelegate Methods

extension AddDepartmentViewController: ChangeSwitchDepartmentDelegate {
    
    func changeActive(newValue: Bool) {
        departmentTemplate.active = newValue
    }
    
    func changeEbt(newValue: Bool) {
        departmentTemplate.itemsEbt = newValue
    }
}

// MARK: - IconsViewControllerDelegate

extension AddDepartmentViewController: IconsViewControllerDelegate {
    
    func iconsViewControllerResponse(icon: Character) {
        departmentTemplate.icon = String(icon)
        tableView.reloadData()
    }
}

// MARK: - SelectedTaxesDelegate 

extension AddDepartmentViewController: SelectedTaxesDelegate {
    
    func selectedTaxes(selectedTaxes: [Tax]) {
        let (newTax, deleteTax) = taxesForRequest(from: oldTaxes, and: selectedTaxes)
        taxesForAdd = newTax
        taxesForRemove = deleteTax
    }
}