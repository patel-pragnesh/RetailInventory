//
//  BarcodeRouter.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/28/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import Alamofire

public enum BarcodeRouter: URLRequestConvertible {
    
    static let baseURLPath = MyConstant.kProxyLookupUrl
    
    case Descriptions(String)
    
    public var URLRequest: NSMutableURLRequest {
        let result: (method: Alamofire.Method, parameters: [String: AnyObject]) = {
            switch self {
            case .Descriptions(let barcode):
                let params = ["code": barcode]
                return (.GET, params)
            }
        }()
        
        let URL = NSURL(string: BarcodeRouter.baseURLPath)!
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.HTTPMethod = result.method.rawValue
        
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}
