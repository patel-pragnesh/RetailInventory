//
//  InventoryDetailCell.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol ChangeSwitchDelegate: class {
    func changeSwitch(state: Bool, tag: Int)
}

class InventoryDetailCell: BaseCell {
    
    static let cellIdentifier = String(InventoryDetailCell)
    
    weak var delegateChangeSwitch: ChangeSwitchDelegate?
    var editable: Bool {
        get {
            return self.detailTextField.enabled
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
    
    @IBOutlet private weak var detailNameLabel: UILabel!
    @IBOutlet private weak var detailTextField: UITextField!
    @IBOutlet private weak var arrowImage: UIImageView!
    @IBOutlet private weak var switchOutlet: UISwitch!
    

    
    // MARK: - Private
    
    private func fillTextField() {
        let detailParameter = DetailName(rawValue: detailType)
        
        switch InventoryDetailData.parameterCell(detailParameter!) {
        case .editNumber:
            configTextField(InventoryListData.detailInventoy(detailParameter!, at: inventory) as? String, keyboardType: .NumberPad)
        case .editWord:
            configTextField(InventoryListData.detailInventoy(detailParameter!, at: inventory) as? String, keyboardType: .Default)
        case .label:
            configTextFieldLikeALabel(InventoryListData.detailInventoy(detailParameter!, at: inventory) as? String)
        case .switchCell:
            confitSwitch(InventoryListData.detailInventoy(detailParameter!, at: inventory) as? Bool)
        }
    }
    
    private func configTextField(defaultText: String?, keyboardType: UIKeyboardType) {
        arrowImage.hidden = true
        
        switchOutlet.hidden = true
        
        detailTextField.enabled = true
        detailTextField.hidden = false
        detailTextField.inputAccessoryView = toolbar()
        detailTextField.keyboardType = keyboardType
        detailTextField.delegate = self
        
        if defaultText != nil {
            detailTextField.text = String(defaultText!)
        } else {
            detailTextField.text = ""
        }
    }
    
    private func configTextFieldLikeALabel(defaultText: String?) {
        detailTextField.enabled = false
        detailTextField.hidden = false
        
        arrowImage.hidden = false
        
        switchOutlet.hidden = true
        
        if defaultText != nil {
            detailTextField.text = defaultText
        } else {
            detailTextField.text = ""
        }
    }
    
    private func confitSwitch(state: Bool?) {
        detailTextField.enabled = false
        detailTextField.hidden = true
        arrowImage.hidden = true
        switchOutlet.hidden = false
        
        if let on = state {
            switchOutlet.on = on
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
    
    // MARK: - Switch change
    
    @IBAction func changeSwitchAction(sender: UISwitch) {
        delegateChangeSwitch?.changeSwitch(sender.on, tag: self.tag)
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

