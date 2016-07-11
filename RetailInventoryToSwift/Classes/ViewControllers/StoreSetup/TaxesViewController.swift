//
//  TaxesViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class TaxesViewController: BaseViewController  {
    
    var taxes = TaxData()
    var editableRow: Int!
    var newTax: Tax?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageForButton(.add)
        configTitles()
        subscribeKeyboardNotification()
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if let tempTax = newTax {
            taxes.removeTax(tempTax)
        }
    }
    
    // MARK: - title
    
    func configTitles() {
        self.navigationItem.title = "taxes.title".localized
    }
    
    // MARK: - navigationBarButton
    
    func imageForButton(type: BarButtonsType) {
        switch type {
        case .add:
            var barItems = [UIBarButtonItem]()
            barItems.append(getBarButtonView(.add))
            self.navigationItem.rightBarButtonItems = barItems
        case .cancel:
            var barItems = [UIBarButtonItem]()
            barItems.append(getBarButtonView(.cancel))
            self.navigationItem.rightBarButtonItems = barItems
        default:
            break
        }

    }
    
    override func addButtonTouch(button: UIButton) {
        imageForButton(.cancel)
        self.navigationItem.rightBarButtonItem?.title = "barItems.cancel".localized
        newTax = taxes.addTax(nil, taxValue: nil)
        taxes.refresh()
        tableView.reloadData()
        if let index = taxes.getIndex(newTax!) {
            animateScrollTableView(NSIndexPath(forRow: 0, inSection: 0), animated: false)
            let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TaxCell
            currentCell.becomeResponder()
        }
        
    }
    
    override func cancelBarButtonTouch(button: UIButton) {
        self.view.endEditing(true)
        imageForButton(.add)
        taxes.removeTax(newTax!)
        taxes.refresh()
        tableView.reloadData()
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
        let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: cellTag, inSection: 0)) as! TaxCell
        currentCell.becomeResponder()
    }
    
    func prevButtonTouch(cellTag: Int) {
        let currentCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: cellTag, inSection: 0)) as! TaxCell
        currentCell.becomeResponder()
    }
    
    func doneButtonTouch(cellTag: Int) {
        imageForButton(.add)
        self.view.endEditing(true)
        if newTax?.taxName == "" || newTax?.taxValue == nil {
            taxes.removeTax(newTax!)
        }
        taxes.refresh()
        tableView.reloadData()
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
        TaxData.editTax(TaxField.taxName, at: taxes.getObjectByIndex(editableRow), value: text)
    }
    
    func taxValueChange(text: String?) {
        TaxData.editTax(TaxField.taxValue, at: taxes.getObjectByIndex(editableRow), value: Double(text!))
    }
}