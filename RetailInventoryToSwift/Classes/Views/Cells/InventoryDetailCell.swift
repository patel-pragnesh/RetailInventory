//
//  InventoryDetailCell.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class InventoryDetailCell: BaseCell {
    
    static let cellIdentifier = String(InventoryDetailCell)
    
    @IBOutlet private weak var detailNameLabel: UILabel!
    @IBOutlet private weak var detailTextField: UITextField!
    @IBOutlet private weak var arrowImage: UIImageView!
    
    var editable: Bool {
        get {
            return self.arrowImage.hidden
        }
    }
    var detailName: String! {
        didSet {
            detailNameLabel.text = detailName
        }
    }
    var detailType: Int!
    var inventory: InventoryList!
    var cellContents: (String, Int, InventoryList)! {
        didSet {
            let (_detailName, _detailType, _inventory) = cellContents
            detailName = _detailName
            detailType = _detailType
            inventory = _inventory
            fillTextField()
        }
    }
    
    // MARK: - Private
    
    private func fillTextField() {
        let detailParameter = DetailName(rawValue: detailType)
        
        switch InventoryDetailMethods.parameterCell(detailParameter!) {
        case .editNumber:
            configTextField(InventoryListMethods.detailInventoy(detailParameter!, at: inventory) as? String, keyboardType: .NumberPad)
        case .editWord:
            configTextField(InventoryListMethods.detailInventoy(detailParameter!, at: inventory) as? String, keyboardType: .Default)
        case .label:
            configTextFieldLikeALabel(InventoryListMethods.detailInventoy(detailParameter!, at: inventory) as? String)
        }
    }
    
    private func configTextField(defaultText: String?, keyboardType: UIKeyboardType) {
        detailTextField.inputAccessoryView = toolbar()
        detailTextField.keyboardType = keyboardType
        arrowImage.hidden = true
        detailTextField.delegate = self
        
        if defaultText != nil {
            detailTextField.text = String(defaultText!)
        } else {
            detailTextField.text = ""
        }
    }
    
    private func configTextFieldLikeALabel(defaultText: String?) {
        detailTextField.enabled = false
        arrowImage.hidden = false
        
        if defaultText != nil {
            detailTextField.text = defaultText
        } else {
            detailTextField.text = ""
        }
    }
    
    // MARK: - Public
    
    func becomeResponder() {
        self.detailTextField.becomeFirstResponder()
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

extension InventoryDetailCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldEndEditing(textField.text, cellTag: self.tag)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldBeginEditing(self.tag)
    }
}

