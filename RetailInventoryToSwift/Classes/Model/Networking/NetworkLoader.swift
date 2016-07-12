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
    
    static func downloadDepartments(completion completion: (departments: [DepartmentResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
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
                let departments = responseJSON.map({ DepartmentResponse.init(withDictionary: $0 as! [String : AnyObject])})
                completion(departments: departments)
        }
    }
    
    static func downloadTaxes(completion completion: (taxs: [TaxResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
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
                let taxes = responseJSON.map({ TaxResponse.init(withDictionary: $0 as! [String: AnyObject]) })
                completion(taxs: taxes)

        }
    }
    
    static func downloadItems(completion completion: (items: [ItemResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
        Alamofire.request(TaxeDepartmentRouter.Items)
            .responseJSON { response in
                guard !response.result.isFailure else {
                    failure(code: 0, message: "unable to network connection or server unreachable")
                    return
                }
                guard response.result.isSuccess else {
                    failure(code: 0, message: "response unsuccessful")
                    return
                }
                print(response.result.value)
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
                let items = responseJSON.map({ ItemResponse.init(withDictionary: $0 as! [String : AnyObject])})
                completion(items: items)
        }
    }
    
    static func downloadSets(completion completion: (sets: [SetResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
        Alamofire.request(TaxeDepartmentRouter.Sets)
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
                let sets = responseJSON.map({ SetResponse.init(withDictionary: $0 as! [String : AnyObject]) })
                completion(sets: sets)
        }
    }
    
    static func downloadTags(completion completion: (tags: [TagResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
        Alamofire.request(TaxeDepartmentRouter.Tags)
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
                let tags = responseJSON.map({ TagResponse.init(withDictionary: $0 as! [String : AnyObject]) })
                completion(tags: tags)
        }
    }
}
