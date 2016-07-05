//
//  AddVendorCell.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol AddVendorCellDelegate
{
    func editing(identCell: AddVendorsMethods.VendorCell, text: String)
    func startEditing()
    func endEditing()
}

class AddVendorCell: BaseCell {
    
    static let cellIdentifier = String(AddVendorCell)
    var identCell = AddVendorsMethods.VendorCell.name
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    var addVendors: AddVendors! {
        didSet {
            self.title.text = addVendors.title
            self.textField.text = addVendors.title
        }
    }
    
    func updateCell(infoCell: VendorTemplate?, identCell: AddVendorsMethods.VendorCell){
        self.identCell = identCell
        textField.inputAccessoryView = toolbar()
        
        if infoCell != nil {
            textField.text = VendorMethods.fieldDetail(VendorField(rawValue: AddVendorsMethods.fieldNameForDetail(identCell))!, vendor: infoCell!)
        }
        textField.placeholder = AddVendorsMethods.placeHolderForCell(identCell)
    }
    
    // MARK: - Public
    
    func becomeResponder() {
        textField.becomeFirstResponder()
    }
    
    //MARK: - ToolBarControlsDelegate
    
    override func nextButtonTouch(cellTag : Int) {
        delegate?.nextButtonTouch(self.tag)
    }
    
    override func prevButtonTouch(cellTag : Int) {
        delegate?.prevButtonTouch(self.tag)
    }
    
    override func doneButtonTouch(cellTag : Int) {
        delegate?.doneButtonTouch(self.tag)
    }
}

// MARK: - UITextFieldDelegate

extension AddVendorCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldEndEditing(textField.text, cellTag: self.tag)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldBeginEditing(self.tag)
    }
}