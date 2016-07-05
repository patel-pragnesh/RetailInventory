//
//  TaxesDepartmentsRouter.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/30/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import Alamofire

public enum TaxeDepartmentRouter: URLRequestConvertible {
    
    static let baseURLPath = MyConstant.kApiUrl
    static let headers = ["X-Access-Token": MyConstant.kUserToken]
    
    case Taxes
    case Departments
    
    public var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method) = {
            switch self {
            case .Taxes:
                let path = MyConstant.kApiPrefix + "taxes"
                return (path, .GET)
            case .Departments:
                let path = MyConstant.kApiPrefix + "departments"
                return (path, .GET)
            }
        }()
        
        
        let URL = NSURL(string: TaxeDepartmentRouter.baseURLPath)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.setValue(MyConstant.kUserToken, forHTTPHeaderField: "X-Access-Token")
        URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: nil).0
    }
}