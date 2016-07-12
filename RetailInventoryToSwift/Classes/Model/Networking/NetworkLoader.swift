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
                completion(taxs: taxes)

        }
    }
    
    static func downloadItems(completion: (items: [ItemResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
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
                let items = responseJSON.map({ ItemResponse(departmentId: ($0["departmentId"] as? Int)!,
                    itemName: ($0["itemName"] as? String)!,
                    itemNotes: ($0["itemNotes"] as? String)!,
                    price: String(($0["price"] as? Int)!),
                    cost: String(($0["cost"] as? Int)!),
                    id: ($0["id"] as? Int)!,
                    barcode: ($0["lookup"] as? String),
                    printItem: ($0["printItem"] as? Bool),
                    openItem: ($0["openItem"] as? Bool),
                    usesWeightScale: ($0["usesWeightScale"] as? Bool),
                    weighted: ($0["weighted"] as? Bool),
                    tareWeight: ($0["tareWeight"] as? Int),
                    itemShortName: ($0["itemShortName"] as? String),
                    qtyOnHand: ($0["qtyOnHand"] as? Int),
                    icon: ($0["icon"] as? String),
                    color: ($0["color"] as? String),
                    active: ($0["active"] as? Bool)
                    )
                })
                completion(items: items)
        }
    }
    
    static func downloadSets(completion: (sets: [SetResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
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
                let sets = responseJSON.map({ SetResponse(active: ($0["active"] as? Bool)!,
                    id: ($0["id"] as? Int)!,
                    manyPer: ($0["manyPer"] as? Bool)!,
                    max: ($0["max"] as? Bool)!,
                    name: ($0["name"] as? String)!
                    )
                })
                completion(sets: sets)
        }
    }
    
    static func downloadTags(completion: (tags: [TagResponse]) -> Void, failure: (code: UInt, message: String) -> Void) {
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
                let tags = responseJSON.map({ TagResponse(active: ($0["active"] as? Bool)!,
                    hidden: ($0["hidden"] as? Bool)!,
                    id: ($0["id"] as? Int)!,
                    itemTagDesc: ($0["itemTagDesc"] as? String)!
                    )
                })
                completion(tags: tags)
        }
    }
}
