//
//  BaseViewController.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/9/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit
import Foundation

class BaseViewController: UIViewController {
    
    enum BarButtonsType: Int {
        case add = 0, scan, question, save, cancel
    }
    let durationAnimate: Double = MyConstant.durationAnimate
    var addBarButton: UIBarButtonItem?
    var saveBarButton: UIBarButtonItem?
    var scanBarButton: UIBarButtonItem?
    var questionBarButton: UIBarButtonItem?
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundView()
        setBackButton()
    }
    
    // MARK: - keyboardNotification
    
    func subscribeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide), name:UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        assert(false, "need to override")
    }
    
    func keyboardWillHide(notification: NSNotification) {
        assert(false, "need to override")
    }
    
    // MARK: - KeyboardInfo
    
    func keyboardFrameInfo(notification: NSNotification) -> CGRect {
        var info = notification.userInfo!
        return (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    }
    
    // MARK: - NavigationBar
    
    func setBackButton() {
        let backBtn: UIBarButtonItem = UIBarButtonItem()
        backBtn.setBackButtonBackgroundImage(UIImage(named: "backButton"), forState: .Normal, barMetrics: .Default)
//        let font = UIFont(name: MyConstant.defaultFont, size: 14)
        // TODO: if set font at inventoryListController back button title = "back"
        backBtn.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()/*, NSFontAttributeName: font!*/], forState: .Normal)
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    func setBackgroundView() {        
        let backgroundView = UIImageView(image: UIImage(named: "viewBgr"))
        backgroundView.frame = self.view.frame
        self.view.insertSubview(backgroundView, atIndex: 0)
    }
    
    func getBarButtonView(type: BarButtonsType) -> UIBarButtonItem {
        switch(type) {
        case .scan:
            scanBarButton = drawBarItem("barItems.scan".localized, imageName: "rightItem", selector: #selector(BaseViewController.scanButtonTouch(_:)))
            return scanBarButton!
        case .question:
            questionBarButton = drawBarItem(nil, imageName: "question", selector: #selector(BaseViewController.questionButtonTouch(_:)))
            return questionBarButton!
        case .add:
            addBarButton = drawBarItem("barItems.add".localized, imageName: "rightItem", selector: #selector(BaseViewController.addButtonTouch(_:)))
            return addBarButton!
        case .save:
            saveBarButton = drawBarItem("barItems.save".localized, imageName: "rightItem", selector: #selector(BaseViewController.saveButtonTouch(_:)))
            return saveBarButton!
        case .cancel:
            saveBarButton = drawBarItem("barItems.cancel".localized, imageName: "rightItem", selector: #selector(BaseViewController.cancelBarButtonTouch(_:)))
            return saveBarButton!
        }
    }
    
    func drawBarItem(title: String?, imageName: String, selector: Selector) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .Custom)
        if title != nil {
            button.setTitle(title, forState: .Normal)
            button.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
            button.titleLabel?.font = UIFont(name: MyConstant.defaultFont, size: 14)
            button.frame.size = CGSize(width: MyConstant.barItemImageWidth, height: MyConstant.barItemImageHeigh)
        } else {
            button.setImage(UIImage(named: imageName), forState: .Normal)
            button.frame.size = CGSize(width: MyConstant.barItemImageHeigh, height: MyConstant.barItemImageHeigh)
            button.layer.cornerRadius = CGRectGetWidth(button.frame) / 2
            button.layer.masksToBounds = true
        }
        button.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let addButton = UIBarButtonItem(customView: button)
        return addButton
    }
    
    // MARK: - Action for navigation bar button
    
    func scanButtonTouch(button: UIButton) {
    }
    
    func cancelBarButtonTouch(button: UIButton) {
    }
    
    func questionButtonTouch(button: UIButton) {
    }
    
    func addButtonTouch(button: UIButton) {
        
    }
    
    func saveButtonTouch(button: UIButton) {
        
    }
}
