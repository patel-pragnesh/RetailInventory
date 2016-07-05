//
//  BaseCell.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/14/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

protocol ToolBarControlsDelegate: class {
    func nextButtonTouch(cellTag: Int)
    func prevButtonTouch(cellTag: Int)
    func doneButtonTouch(cellTag: Int)
    func textFieldEndEditing(text: String?, cellTag: Int)
    func textFieldBeginEditing(cellTag: Int)
}

class BaseCell: UITableViewCell, ToolBarControlsDelegate{
    
    var heightCell: CGFloat {
        return MyConstant.defaultCellHeigh
    }
    
    var backgroundType: UIImageView! {
        didSet {
            self.backgroundView = backgroundType
        }
    }
    
    var delegate: ToolBarControlsDelegate?
    
    // MARK: - ToolBar for keyboard
    
    func toolbar() -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0,
            y: 0,
            width: (self.frame.width),
            height: MyConstant.toolbarHeigh))
        
        toolbar.setBackgroundImage(UIImage(named:"sheetBgr"), forToolbarPosition: .Any, barMetrics: .Default)
        toolbar.translucent = false
        
        let fixedItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedItem.width = 10
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        var toolbarItems = [UIBarButtonItem]()
        toolbarItems.append(drawToolbarItem(nil, imageName: "prev", selector: "prevTouch:"))
        toolbarItems.append(drawToolbarItem(nil, imageName: "next", selector: "nextTouch:"))
        toolbarItems.append(flexibleItem)
        toolbarItems.append(drawToolbarItem("barItems.done".localized, imageName: "rightItem", selector: "doneTouch:"))
        toolbarItems.append(fixedItem)

        toolbar.items = toolbarItems
        
        return toolbar
    }
    
    func drawToolbarItem(title: String?, imageName: String, selector: String) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .Custom)
        if title != nil {
            button.setTitle(title, forState: .Normal)
            button.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
            button.titleLabel?.font = UIFont(name: MyConstant.defaultFont, size: 13)
        } else {
            button.setImage(UIImage(named: imageName), forState: .Normal)
        }
        button.addTarget(self, action: Selector(selector), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame.size = CGSize(width: MyConstant.barItemImageWidth, height: MyConstant.barItemImageHeigh)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let addButton = UIBarButtonItem(customView: button)
        return addButton
    }
    
    //MARK: - ToolBar actions
    
    func nextTouch(button: UIButton) {
        delegate?.nextButtonTouch(self.tag)
    }
    
    func prevTouch(button: UIButton) {
        delegate?.prevButtonTouch(self.tag)
    }
    
    func doneTouch(button: UIButton) {
        delegate?.doneButtonTouch(self.tag)
    }
    func textFieldEndEditing(text: String?, cell: UITableViewCell) {
        delegate?.textFieldEndEditing(text, cellTag: self.tag)
    }
    
    //MARK: - ToolBarControlsDelegate
    
    func nextButtonTouch(cellTag: Int) {
        
    }
    
    func prevButtonTouch(cellTag: Int) {
        
    }
    
    func doneButtonTouch(cellTag: Int) {
        
    }
    
    func textFieldEndEditing(text: String?, cellTag: Int) {
        
    }
    
    func textFieldBeginEditing(cellTag: Int) {
        
    }
}
