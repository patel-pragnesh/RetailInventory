//
//  Constant.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/16/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import UIKit

struct MyConstant {
    static let durationAnimate: Double = 0.5
    static let barItemImageHeigh: CGFloat = 30
    static let barItemImageWidth: CGFloat = 60
    static let defaultCellHeigh: CGFloat = 70
    static let toolbarHeigh: CGFloat = 40
    static let defaultIdentToKeyboard: CGFloat = 10
    static let iconSize: CGFloat = 24
    static let defaultFont: String = "HelveticaNeue-Bold"
    static let titleFont: String = "HelveticaNeue"

    static let segueDepartments = "departmentsSegue"
    static let segueVendors = "vendorsSegue"
    static let segueTaxes = "taxesSegue"
    static let segueSelectDescription = "selectDescription"
    static let segueFromDepartments = "departmentsSegue"
    static let segueFromVendors = "vendorsSegue"
    static let segueFromTaxes = "taxesSegue"
    static let segueScan = "scanBarCode"
    
    static let segueSelectDepartments = "segueSelectDepartments"
    static let segueSelectTaxes = "segueSelectTaxes"
    static let segueSelectVendors = "segueSelectVendors"
    static let segueInventaryDetail = "inventoryDetail"

    static let segueAddListFromButtonDepartment = "addListSegueFromButtonDepartment"
    static let segueAddListFromButtonVendor = "addListSegueFromButtonVendor"
    static let segueAddListFromCellDepartment = "addListSegueFromCellDepartment"
    static let segueAddListFromCellVendor = "addListSegueFromCellVendor"
    
    static let segueIcon = "iconSegue"
    static let segueAppliedTaxes = "appliedTaxesSegue"
    static let segueAppliedItems = "appliedItemsSegue"
    
    // Network

    static let kProxyLookupUrl = "http://54.227.169.178:8080/awsproxy/combined/getCombined"
    static let kUserToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiI0Mzk4ZTc3ZmRmNmQ2ODM5Y2E5NjJlYWI1MjdjMDY3MmRkYmY4MWM2NGE3OWYxM2VkYjExMGMwYzI1MTRjZDAwIiwiZXhwIjoxNDcwODM5ODc2MTM3fQ.S_U7qnGXLbSZlmhNrul7gc0EDWRJjYf6pJzT7UJeRo7orbD3zuTwEo_iHG2bw0CrZojBAen3r7FJpeFuCTBrNw"
    static let kApiUrl = "https://echo.harbortouch.com/"
    static let kApiPrefix = "api/v1/"
    static let kApiTaxes = "taxes"
    static let kApiDepartments = "departments"
    
    // Key for Defaults
    
    static let keyForLookUP = "lookUpItemDescirption"
    static let keyForCostTracking = "costTracking"
    
    // DataBase
    
    static let dataBaseName = "RetailInventoryToSwift"
}