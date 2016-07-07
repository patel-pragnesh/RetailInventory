//
//  VendorTemplate.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/4/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit

struct VendorTemplate {
    var accountNumber: String?
    var alias: String?
    var city: String?
    var name: String?
    var phone: String?
    var state: String?
    var street: String?
    var zip: String?
    
    subscript(key: String) -> AnyObject? {
        get {
            switch key {
            case "accountNumber":
                return accountNumber
            case "alias":
                return alias
            case "city":
                return city
            case "name":
                return name
            case "phone":
                return phone
            case "state":
                return state
            case "street":
                return street
            case "zip":
                return zip
            default:
                return nil
            }
        }
        set(value) {
            switch key {
            case "accountNumber":
                accountNumber = value as? String
            case "alias":
                alias = value as? String
            case "city":
                city = value as? String
            case "name":
                name = value as? String
            case "phone":
                phone = value as? String
            case "state":
                state = value as? String
            case "street":
                street = value as? String
            case "zip":
                zip = value as? String
            default: assert(true, "you do something wrong")
            }
        }
    }
}
