//
//  NetworkLoader.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/29/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import Alamofire

class NetworkLoader {
    static func downloadDescription(barcode: String, progress: (percent: Float) -> Void, completion: (descriptions: [String]) -> Void) {
        Alamofire.request(BarcodeRouter.Descriptions(barcode))
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                dispatch_async(dispatch_get_main_queue()) {
                    progress(percent: Float(totalBytesRead))
                }
            }
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("response unseccesful")
                    completion(descriptions: [String]())
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject],
                    listDescriptions = responseJSON["items"] as? [String] else {
                        print("bad result")
                        completion(descriptions: [String]())
                        return
                }
                completion(descriptions: listDescriptions)
        }
    }
    
    static func downloadDepartments(completion: (departments: [DepartmentResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
                Alamofire.request(TaxeDepartmentRouter.Departments)
            .responseJSON { response in
                guard !response.result.isFailure else {
                    failure(code: 0, message: "unable to network connection or server unreachable")
                    return
                }
                guard response.result.isSuccess else {
                    failure(code: 0, message: "response unsuccessful")
                    return
                }
                guard let responseJSON = response.result.value as? [AnyObject] else {
                    guard let fail = response.result.value as AnyObject! else {
                        return
                    }
                    guard let error = fail["error"] as AnyObject! else {
                        return
                    }
                    guard let code = error["code"] as? UInt else {
                        return
                    }
                    guard let message = error["message"] as? String else {
                        return
                    }
                    
                    failure(code: code, message: message)
                    return
                }
                var departments = [DepartmentResponse]()
                responseJSON.forEach({ department in
                    let taxes = department["taxes"] as? [AnyObject]
                    var arrayID = [Int]()
                    taxes!.forEach({tax in
                        arrayID.append((tax["id"] as? Int)!)
                    })
                    departments.append(DepartmentResponse( name: (department["name"] as? String)!,
                        id: (department["id"] as? Int)!,
                        active: (department["active"] as? Bool)!,
                        itemsAreEBT: (department["ebtItem"] as? Bool)!,
                        glyph: (department["glyph"] as? String)!,
                        taxesId: arrayID
                    ))
                })
//                print("------------- departmetns -----------------")
//                print(departments)
                completion(departments: departments)
        }
    }
    
    static func downloadTaxes(completion: (taxs: [TaxResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
        Alamofire.request(TaxeDepartmentRouter.Taxes)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("request unseccesful")
                    completion(taxs: [TaxResponse]())
                    return
                }
                guard let responseJSON = response.result.value as? [AnyObject] else {
                    guard let fail = response.result.value as AnyObject! else {
                        return
                    }
                    guard let error = fail["error"] as AnyObject! else {
                        return
                    }
                    guard let code = error["code"] as? UInt else {
                        return
                    }
                    guard let message = error["message"] as? String else {
                        return
                    }
                    
                    failure(code: code, message: message)
                    return
                }
                let taxes = responseJSON.map({ TaxResponse(name: ($0["name"] as? String)!,percent: ($0["percent"] as? Double)!, id: ($0["id"] as? Int)!, active: ($0["active"] as? Bool)!) })
//                print("------------- taxes -----------------")
//                print(responseJSON)
                completion(taxs: taxes)

        }
    }
}
