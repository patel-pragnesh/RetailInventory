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
    var selectedItems: [InventoryList]!
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
        
        oldTaxes = TaxMethods.taxesByDepartment(departmentTemplate.id!)
        selectedItems = InventoryListMethods.itemsByDepartment(departmentTemplate.id!)
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
            upcoming.selectedItems = selectedItems
        }
        if segue.identifier == MyConstant.segueAppliedTaxes {
            let upcoming = segue.destinationViewController as! AppliedTaxesViewController
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
    
    private func updateOldTaxes() {
        for taxAdd in taxesForAdd! {
            oldTaxes.append(taxAdd)
        }
        for taxRemove in taxesForRemove! {
            oldTaxes.removeAtIndex(oldTaxes.indexOf(taxRemove)!)
        }
    }
    
    private func oldTaxesToString() -> String {
        var taxes = String()
        if oldTaxes.count > 1 {
            for i in  0 ... oldTaxes.count - 2 {
                taxes += oldTaxes[i].taxName! + ", "
            }
            taxes += (oldTaxes.last?.taxName!)!
            return taxes
        } else {
            if oldTaxes.count == 0 {
                return ""
            } else {
                return (oldTaxes.first?.taxName)!
            }
        }
    }
    
    // MARK: - navigationBarButton
    
    func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.save))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    override func saveButtonTouch(button: UIButton) {
        
        self.view.endEditing(true)
        
        if needUpdateTaxes {
            SocketClient.checkConnection()
            
            networkActivity.hidden = false
            networkActivity.startAnimating()
            
            switch typeWorking! {
            case .add:
                countRequest += 1
                sendNewDepartment()
            case .edit:
                countRequest += 1
                sendEditDepartment()
            }
        }
        sendTaxesToServer()
    }
    
    func sendNewDepartment() {
        SocketClient.createDepartment(departmentTemplate,
                                      failure: { (code, error) in
                                        switch code {
                                        case .fail:
                                            self.errorAlert(error!)
                                        default:
                                            self.countCompletedRequest += 1
                                            self.stopAnimateNetworkActivity()
                                            self.needUpdateTaxes = false
                                        }
        })
    }
    
    func sendEditDepartment() {
        SocketClient.updateDepartment(departmentTemplate,
                                      failure: { (code, error) in
                                        switch code {
                                        case .fail:
                                            self.errorAlert(error!)
                                        default:
                                            self.countCompletedRequest += 1
                                            self.stopAnimateNetworkActivity()
                                            self.needUpdateTaxes = false
                                        }
        })
    }
    
    func sendTaxesToServer() {
        if taxesForAdd?.count > 0 {
            for tax in taxesForAdd! {
                countRequest += 1
                SocketClient.taxMapCreate(tax.id as! Int, DepartmentId: departmentTemplate.id as! Int,
                                          failure: { (code, error) in
                                            switch code {
                                            case .fail:
                                                self.errorAlert(error!)
                                            default:
                                                self.countCompletedRequest += 1
                                                self.stopAnimateNetworkActivity()
                                            }
                                            self.taxesForAdd = nil
                })
            }
        }
        if taxesForRemove?.count > 0 {
            for tax in taxesForRemove! {
                countRequest += 1
                SocketClient.taxMapDelete(tax.id as! Int, DepartmentId: departmentTemplate.id as! Int,
                                          failure: { (code, error) in
                                            switch code {
                                            case .fail:
                                                self.errorAlert(error!)
                                            default:
                                                self.countCompletedRequest += 1
                                                self.stopAnimateNetworkActivity()
                                            }
                                            self.taxesForRemove = nil
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
    
    func errorAlert(error: [String: AnyObject]) {
        
        let errorAlert = UIAlertController(title:"\(error["code"]!)", message: "\(error["message"]!)", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "storeSetup.alertCancel".localized, style: .Default) { (action:UIAlertAction!) in
            self.networkActivity.hidden = true
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
                        identCell: addDepartmentMethods.enumCell(indexPath.row),
                        taxes: oldTaxesToString(),
                        countItems: selectedItems.count)
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
                needUpdateTaxes = true
            } else {
                var error = [String: AnyObject]()
                error["code"] = 0
                error["message"] = "name must have value"
                errorAlert(error)
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
        needUpdateTaxes = true
    }
    
    func changeEbt(newValue: Bool) {
        departmentTemplate.itemsEbt = newValue
        needUpdateTaxes = true
    }
}

// MARK: - IconsViewControllerDelegate

extension AddDepartmentViewController: IconsViewControllerDelegate {
    
    func iconsViewControllerResponse(icon: Character) {
        departmentTemplate.icon = String(icon)
        tableView.reloadData()
        needUpdateTaxes = true
    }
}

// MARK: - SelectedTaxesDelegate 

extension AddDepartmentViewController: SelectedTaxesDelegate {
    
    func selectedTaxes(selectedTaxes: [Tax]) {
        let (newTax, deleteTax) = taxesForRequest(from: oldTaxes, and: selectedTaxes)
        taxesForAdd = newTax
        taxesForRemove = deleteTax
        updateOldTaxes()
        tableView.reloadData()
    }
}