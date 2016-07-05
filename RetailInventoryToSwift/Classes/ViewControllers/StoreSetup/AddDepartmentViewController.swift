//
//  AddDepartmentViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol AddDepartmentViewControllerDelegate
{
    func addDepartmentToBase(info: DepartmentTemplate)
    func editDepartmentToBase(info: DepartmentTemplate)
}

class AddDepartmentViewController: BaseViewController {
    
    var addDepartmentMethods = AddDepartmentsMethods()
    var delegateAddDepartmentViewController: AddDepartmentViewControllerDelegate?
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
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageForButton()
        titleView()
        subscribeKeyboardNotification()
    }
    
    // MARK: - title
    
    func titleView() {
        switch typeWorking! {
        case .add:
            self.navigationItem.title = "addDepart.titleAdd".localized
        case .edit:
            self.navigationItem.title = "addDepart.titleEdit".localized            
        }
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

    
    // MARK: - segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier ==  MyConstant.segueIcon {
            let iconViewController = segue.destinationViewController as! IconsViewController
            iconViewController.delegateIconViewController = self
        }
    }
    
    // MARK: - navigationBarButton
    
    func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.save))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    override func saveButtonTouch(button: UIButton) {
        switch typeWorking! {
        case .add:
            self.delegateAddDepartmentViewController?.addDepartmentToBase(departmentTemplate)
        case .edit:
            self.delegateAddDepartmentViewController?.editDepartmentToBase(departmentTemplate)
        }
        navigationController?.popViewControllerAnimated(true)
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
        cell.updateCell(addDepartmentMethods.parameterCell(addDepartmentMethods.enumCell(indexPath.row)), infoCell: departmentTemplate, identCell: addDepartmentMethods.enumCell(indexPath.row))
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
            departmentTemplate.name = text
        case .id:
            departmentTemplate.id = Int(text!)
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

// MARK: - IconsViewControllerDelegate Methods

extension AddDepartmentViewController: IconsViewControllerDelegate {
    
    func iconsViewControllerResponse(icon: Character)
    {
        departmentTemplate.icon = String(icon)
        tableView.reloadData()
    }
}