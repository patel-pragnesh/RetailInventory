//
//  String.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/15/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
             return try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            }catch {
                return nil
            }
            
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
