//
//  AddVendorViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol AddVendorViewControllerDelegate: class {
    func addVendorToBase(info: VendorTemplate)
    func editVendorToBase(info: VendorTemplate)
}

enum ControllerTypeWorking: Int {
    case add = 0, edit
}

class AddVendorViewController: BaseViewController {
    
    weak var delegateAddVendorViewControllerDelegate: AddVendorViewControllerDelegate?
    
    var addVendorMethods = AddVendorsMethods()
    var typeWorking: ControllerTypeWorking!
    var vendorTemplate = VendorTemplate()
    var editableRow: Int!
    var editableVendor: Vendor? {
        didSet {
            vendorTemplate.accountNumber = editableVendor?.accountNumber
            vendorTemplate.alias = editableVendor?.alias
            vendorTemplate.city = editableVendor?.city
            vendorTemplate.name = editableVendor?.name
            vendorTemplate.phone = editableVendor?.phone
            vendorTemplate.state = editableVendor?.state
            vendorTemplate.street = editableVendor?.street
            vendorTemplate.zip = editableVendor?.zip
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageForButton()
        configTitles()
        subscribeKeyboardNotification()
    }
    
    // MARK: - title
    
    func configTitles() {
        switch typeWorking! {
        case .add:
            self.navigationItem.title = "addVendor.titleAdd".localized
        case .edit:
            self.navigationItem.title = "addVendor.titleEdit".localized
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

    // MARK: - navigationBarButton
    
    func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.save))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    override func saveButtonTouch(button: UIButton) {
        self.view.endEditing(true)
        switch typeWorking! {
        case .add:
            self.delegateAddVendorViewControllerDelegate?.addVendorToBase(vendorTemplate)
        case .edit:
            self.delegateAddVendorViewControllerDelegate?.editVendorToBase(vendorTemplate)
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
            if index == addVendorMethods.count {
                index = 0
            }
        } else {
            index -= 1
            if index < 0 {
                index = addVendorMethods.count - 1
            }
        }
        animateScrollTableView(NSIndexPath(forRow: index, inSection: 0), animated: false)
        let newCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! AddVendorCell
        newCell.becomeResponder()
    }
}

// MARK: - tableView DataSourse

extension AddVendorViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addVendorMethods.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddVendorCell.cellIdentifier, forIndexPath: indexPath) as! AddVendorCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        tableView.rowHeight = cell.heightCell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.addVendors = addVendorMethods.getObjectByIndex(indexPath.row)
        cell.updateCell(vendorTemplate, identCell: addVendorMethods.enumCell(indexPath.row))
        return cell
    }
}

// MARK: - ToolBarControlsDelegate

extension AddVendorViewController: ToolBarControlsDelegate {
    
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
        switch AddVendorsMethods.VendorCell(rawValue: cellTag)! {
            case .name:
                vendorTemplate.name = text
            case .alias:
                vendorTemplate.alias = text
            case .street:
                vendorTemplate.street = text
            case .сity:
                vendorTemplate.city = text
            case .state:
                vendorTemplate.state = text
            case .zip:
                vendorTemplate.zip = text
            case .accountNumber:
                vendorTemplate.accountNumber = text
            case .phone:
                vendorTemplate.phone = text
            }
    }
    
    func textFieldBeginEditing(cellTag: Int) {
        editableRow = cellTag
    }
}