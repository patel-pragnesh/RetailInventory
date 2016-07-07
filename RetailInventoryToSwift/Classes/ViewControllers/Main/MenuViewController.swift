//
//  MenuViewController.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 06.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {

    @IBOutlet weak var inventoryListButton: UIButton!
    @IBOutlet weak var adjustStockButton: UIButton!
    @IBOutlet weak var setupStorButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    //MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configTitles()
        configAdjustStockButton()
        rightBarItems()
    }
    
    // MARK: - Private
    
    private func configTitles() {
        inventoryListButton.setTitle("menu.inventoryListButton".localized, forState: .Normal)
        adjustStockButton.setTitle("menu.adjustStockButton".localized, forState: .Normal)
        setupStorButton.setTitle("menu.setupStoreButton".localized, forState: .Normal)
        self.navigationItem.title = "menu.menuTitle".localized
    }
    
    private func configAdjustStockButton() {
        adjustStockButton.titleLabel?.lineBreakMode = .ByWordWrapping
        adjustStockButton.titleLabel?.textAlignment = .Center
    }
    
    private func rightBarItems() {
        var barItems = [UIBarButtonItem]()
        barItems.append(getBarButtonView(.question))
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    // MARK: - Bar Items Actions
    
    @IBAction func onLogOutTouch(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Buttons Actions
    
    @IBAction func onInventoryListTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("showInventary", sender: self)
    }
    @IBAction func onAjustStockTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("showStock", sender: self)
    }
    @IBAction func onStoreSetupTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("showStoreSetup", sender: self)
    }
}
