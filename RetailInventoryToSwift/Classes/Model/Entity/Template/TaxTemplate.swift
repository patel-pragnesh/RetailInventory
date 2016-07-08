//
//  TaxTemplate.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/5/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

struct TaxTemplate {
    var taxName: String?
    var taxValue: NSNumber?
    var id: NSNumber?
    var active: Bool?
    
    static func taxMapAsDictionaryForRequest(taxId: Int, depId: Int) -> [String:AnyObject] {
        var tax = [String:AnyObject]()
        tax["taxId"] = taxId
        tax["departmentId"] = depId
        
        return tax
    }
}