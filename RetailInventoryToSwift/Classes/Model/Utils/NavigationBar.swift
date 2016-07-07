//
//  NavigationBar.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/13/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    static func setDefaultStyles() {
        let appereance = UINavigationBar.appearance()
        let font = UIFont(name: MyConstant.titleFont, size: 15)
        appereance.setBackgroundImage(UIImage(named: "navBar.png"), forBarMetrics: .Default)
        appereance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font!]
    }
}