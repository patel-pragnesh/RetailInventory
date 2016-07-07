//
//  AddDepartmentCell.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 28.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol ChangeSwitchDepartmentDelegate: class {
    
    func changeActive(newValue: Bool)
    func changeEbt(newValue: Bool)
}

class AddDepartmentCell: BaseCell {
    
    var delegateChangeSwitch: ChangeSwitchDepartmentDelegate?
    
    static let cellIdentifier = String(AddDepartmentCell)
    
    var editable: Bool {
        get {
            return nameTextField.enabled
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var switchCell: UISwitch!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    
    var addDepartments: String! {
        didSet {
            self.titleLabel.text = addDepartments
        }
    }
    
    func updateCell(typeCell: AddDepartmentsMethods.CellType, infoCell: DepartmentTemplate?, identCell: DepartmentCell){
        nameTextField.inputAccessoryView = toolbar()
        self.titleLabel.hidden = false
        
        switch typeCell {
        case .inputText:
            switchCell.hidden = true
            arrowImageView.hidden = true
            nameTextField.text = infoCell?.name
        case .switchCell:
            arrowImageView.hidden = true
            nameTextField.enabled = false
            switchCell.hidden = false
            switch identCell {
                case .active:
                    switchCell.on = infoCell?.active == 1 ? true : false
                case .ebt:
                    switchCell.on = infoCell?.itemsEbt == 1 ? true : false
                default:
                    break
                }
        case .icon:
            switchCell.hidden = true
            arrowImageView.hidden = false
            nameTextField.enabled = false
            nameTextField.font = UIFont(name: "FontAwesome", size: MyConstant.iconSize)
            nameTextField.text = infoCell?.icon
        case .link:
            switchCell.hidden = true
            arrowImageView.hidden = false
            nameTextField.enabled = false
            switch identCell {
                case .items:
                    nameTextField.text = "" // maybe need input count applied items
                case .taxes:
                    nameTextField.text = "" // maybe need input count applied taxes
                default:
                    break
            }            
        }
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        switch DepartmentCell(rawValue: self.tag)! {
        case .active:
            delegateChangeSwitch?.changeActive(switchCell.on)
        case .ebt:
            delegateChangeSwitch?.changeEbt(switchCell.on)
        default:
            return
        }
    }
    
    // MARK: - Public
    
    func becomeResponder() {
        self.nameTextField.becomeFirstResponder()
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

extension AddDepartmentCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldEndEditing(textField.text, cellTag: self.tag)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldBeginEditing(self.tag)
    }
}