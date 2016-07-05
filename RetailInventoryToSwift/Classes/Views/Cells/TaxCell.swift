//
//  TaxCell.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol TaxCellDelegate: class {
    func taxNameChange(text: String?)
    func taxValueChange(text: String?)
}

class TaxCell: BaseCell {
    
    static let cellIdentifier = String(TaxCell)
    
    var delegateTaxCell: TaxCellDelegate?
    var editName: Bool {
        get {
            return nameTextField.editing
        }
    }
    
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var labelValue: UILabel!
    @IBOutlet private weak var labelName: UILabel!
    
    var tax: Tax? {
        didSet {
            nameTextField.inputAccessoryView = toolbar()
            valueTextField.inputAccessoryView = toolbar()
            valueTextField.keyboardType = .DecimalPad
            
            self.labelName.text = "taxes.nameTax".localized
            self.labelValue.text = "taxes.valueTax".localized
            if tax != nil {
                if tax!.taxName != nil {
                    nameTextField.text = tax!.taxName
                } else {
                    nameTextField.text = ""
                }
                if tax!.taxValue != nil {
                    valueTextField.text = String(tax!.taxValue!)
                } else {
                    valueTextField.text = ""
                }
            }
        }
    }
    
    // MARK: - Public
    
    func becomeResponder() {
        if nameTextField.editing {
            valueTextField.becomeFirstResponder()
        } else {
            nameTextField.becomeFirstResponder()
        }
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

extension TaxCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == nameTextField {
            delegateTaxCell?.taxNameChange(textField.text)
        } else {
            delegateTaxCell?.taxValueChange(textField.text)
        }
        delegate?.textFieldEndEditing(textField.text, cellTag: self.tag)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldBeginEditing(self.tag)
    }
}