//
//  StoreSetupCell.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 09.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol ChangeSwitchStoreSetupDelegate: class {
    
    func changeLookUpItem(newValue: Bool)
    func changeCostTracking(newValue: Bool)
}

class StoreSetupCell: BaseCell {
    
    static let cellIdentifier = String(StoreSetupCell)
    var delegateChangeSwitch: ChangeSwitchStoreSetupDelegate?
    
    @IBOutlet private weak var imageViewCell: UIImageView!
    @IBOutlet private weak var titleLabelCell: UILabel!
    @IBOutlet private weak var infoLabelCell: UILabel!
    @IBOutlet private weak var arrowImageViewCell: UIImageView!
    @IBOutlet private weak var switchCell: UISwitch!
    
    var cellContents: (Int, StoreSetup, Bool, Bool)! {
        didSet {
            let (cellTag, storeSetup, costState, lookUpState) = cellContents
            self.tag = cellTag
            self.storeSetup = storeSetup
            self.costState = costState
            self.lookUpState = lookUpState
            updateCell(StoreSetupMethods.parameterCell(StoreSetupCells(rawValue: self.tag)!))
            stateFotSwicth()
        }
    }
    
    var costState: Bool!
    var lookUpState: Bool!

    var storeSetup: StoreSetup! {
        didSet {
            self.titleLabelCell.text = storeSetup.title!
            if storeSetup.image != nil {
                self.imageViewCell.image = storeSetup.image
            }
            if storeSetup.info != nil {
                self.infoLabelCell.text = storeSetup.info
            }
        }
    }
    
    override var heightCell: CGFloat {
        return 70
    }
    
    // MARK: - Private
    
    private func stateFotSwicth() {
        switch StoreSetupCells(rawValue: self.tag)! {
        case .cost:
            switchCell.on = costState
        case .lookup:
            switchCell.on = lookUpState
        default:
            return
        }
    }
    
    private func updateCell(numerationCell: parametersCell) {
        self.titleLabelCell.hidden = false
        self.imageViewCell.hidden = true
        self.arrowImageViewCell.hidden = true
        self.infoLabelCell.hidden = true
        self.switchCell.hidden = true
        switch numerationCell {
        case .segueCell:
            self.imageViewCell.hidden = false
            self.arrowImageViewCell.hidden = false
            self.infoLabelCell.hidden = false
        case .switchCell:
            self.imageViewCell.hidden = false
            self.switchCell.hidden = false
        case .infoCell:
            self.infoLabelCell.hidden = false
        case .defaultCell:
            break
        }
    }
    
    // MARK: - switchChanged
    
    @IBAction func switchChanged(sender: AnyObject) {
        switch StoreSetupCells(rawValue: self.tag)! {
        case .cost:
            delegateChangeSwitch?.changeCostTracking(switchCell.on)
        case .lookup:
            delegateChangeSwitch?.changeLookUpItem(switchCell.on)
        default:
            return
        }
    }
}