//
//  TaxesViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class TaxesViewController: BaseViewController  {
    
    var taxes = TaxMethods()
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
        self.navigationItem.title = "taxes.title".localized
    }
    
    // MARK: - navigationBarButton
    
    func imageForButton() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.add))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    override func addButtonTouch(button: UIButton) {
        let newTax = taxes.addTax(nil, taxValue: nil)
        taxes.refresh()
        tableView.reloadData()
        if let index = taxes.getIndex(newTax) {
            let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaxCell
            currentCell.becomeResponder()
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
    
    // MARK: - Animation scroll tableView
    
    func animateScrollTableView(indexPath: NSIndexPath, animated: Bool) {
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: animated)
    }
    
    // MARK: - ChangeResponder
    
    func changeResponder(tag: Int, changeToUp: Bool) {
        var index = tag
        let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaxCell
        if currentCell.editName {
            if changeToUp {
                currentCell.becomeResponder()
                return
            }
        } else {
            if !changeToUp {
                currentCell.becomeResponder()
                return
            }
        }
        if changeToUp {
            index += 1
            if index == taxes.count {
                index = 0
            }
        } else {
            index -= 1
            if index < 0 {
                index = taxes.count - 1
            }
        }
        animateScrollTableView(NSIndexPath(forRow: index, inSection: 0), animated: false)
        let newCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaxCell
        newCell.becomeResponder()
    }
}

// MARK: - tableView DataSourse

extension TaxesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taxes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TaxCell.cellIdentifier, forIndexPath: indexPath) as! TaxCell
        cell.backgroundType = tableView.backgroundForTableCell(at: indexPath)
        tableView.rowHeight = cell.heightCell
        cell.delegate = self
        cell.delegateTaxCell = self
        cell.tag = indexPath.row
        cell.tax = taxes.getObjectByIndex(indexPath.row)

        return cell
    }
}

// MARK: - tableView Delegate

extension TaxesViewController: UITableViewDelegate {
    
}

// MARK: - ToolBarControlsDelegate

extension TaxesViewController: ToolBarControlsDelegate {
    
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
    }
    
    func textFieldBeginEditing(cellTag: Int) {
        editableRow = cellTag
    }
}

extension TaxesViewController: TaxCellDelegate {
    
    func taxNameChange(text: String?) {
        TaxMethods.editTax(TaxField.taxName, at: taxes.getObjectByIndex(editableRow), value: text)
    }
    
    func taxValueChange(text: String?) {
        TaxMethods.editTax(TaxField.taxValue, at: taxes.getObjectByIndex(editableRow), value: Double(text!))
    }
}