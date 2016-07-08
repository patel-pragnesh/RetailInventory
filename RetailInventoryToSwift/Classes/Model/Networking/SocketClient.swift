//
//  SocketClient.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/6/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import SocketIOClientSwift

enum ResponseCode: Int {
    case fail, depCreate, depUpdate, taxMapCreate, taxMapDelete
}

class SocketClient {
    
    static let keyUpdateDepartment = "departments:update"
    static let keyCreateDepartment = "departments:create"
    static let keyTaxMapCreate = "deptTaxMap:create"
    static let keyTaxMapDelete = "deptTaxMap:delete"
    
    
    static var socket: SocketIOClient?
    static var failure: ((ResponseCode, [String: AnyObject]?) -> Void)?
    
    static func initSocket() {
        socket = SocketIOClient(socketURL: NSURL(string: MyConstant.socketURL)!, options: [.ForcePolling(true)])
        addHandlers()
    }
    
    static func disconnect() {
        print("disconnect")
        socket!.disconnect()
    }
    
    static func connect() {
        print("connect")
        socket!.connect()
    }
    
    static func checkConnection() {
        print(socket!.status.rawValue)
        if socket!.status == .Disconnected {
            print("reconnect")
            socket?.reconnect()
        }
    }
    
    static func addHandlers() {
        socket?.on("command response") {data, ack in
            let response = (data[0] as! String).parseJSONString! as? [String: AnyObject]
            
            let (responseCode, responseValue) = parseResponse(response!)
            
            switch responseCode {
            case .depCreate:
                DepartmentMethods.addDepartmentFromResponse(responseValue)
            case .depUpdate:
                DepartmentMethods.updateDepartmentFromResponse(responseValue)
            case .taxMapCreate:
                TaxMethods.addTaxMapFromResponse(responseValue)
            case .taxMapDelete:
                TaxMethods.removeTaxMapFromResponse(responseValue)
            case .fail:
                failure?(responseCode, responseValue)
                return
            }
            failure?(responseCode, nil)
            
        }
        
        socket?.on("command error") { data, ack in
            let response = (data[0] as! String).parseJSONString! as? [String: AnyObject]
            print("command error") // TODO: print
            print (response)
            if response!["error"] != nil {
                if let errorContext = response!["error"] as? [String: AnyObject] {
                    failure?(ResponseCode.fail, errorContext)
                }
            }
        }
    }
    
    static func updateDepartment(departmentTemplate: DepartmentTemplate, failure:(ResponseCode, [String: AnyObject]?) -> Void) {
        var department = departmentTemplate.asDictionaryForRequest()

        department["token"] = MyConstant.kUserToken
        
        var items = department
        items["event"] = keyUpdateDepartment
            
        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static func createDepartment(departmentTemplate: DepartmentTemplate, failure: (ResponseCode, [String: AnyObject]?) -> Void) {
        var department = departmentTemplate.asDictionaryForRequest()
        
        department["token"] = MyConstant.kUserToken
        
        var items = department
        items["event"] = keyCreateDepartment

        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static func taxMapCreate(taxId: Int, DepartmentId: Int, failure: (ResponseCode, [String: AnyObject]?) -> Void) {
        var tax = TaxTemplate.taxMapAsDictionaryForRequest(taxId, depId: DepartmentId)
        
        tax["token"] = MyConstant.kUserToken
        
        var items = tax
        items["event"] = keyTaxMapCreate

        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static func taxMapDelete(taxId: Int, DepartmentId: Int, failure: (ResponseCode, [String: AnyObject]?) -> Void) {
        var tax = TaxTemplate.taxMapAsDictionaryForRequest(taxId, depId: DepartmentId)
        
        tax["token"] = MyConstant.kUserToken
        
        var items = tax
        items["event"] = keyTaxMapDelete

        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static private func parseResponse(response: AnyObject) -> (code: ResponseCode, responseValue: [String: AnyObject]) {
        let responseDictionary = response as? [String: AnyObject]
        print ("++++++++++++++++++++++++")
        print(responseDictionary)
        print ("++++++++++++++++++++++++")
        if responseDictionary!["error"] != nil {
            if let errorContext = responseDictionary!["error"] as? [String: AnyObject] {
                print(errorContext)
                var error = [String: AnyObject]()
                error["code"] = errorContext["code"] as? UInt
                error["message"] = errorContext["message"] as? String
                error["details"] = errorContext["details"] as? String
                return (ResponseCode.fail, error)
            }
        }
        let event = responseDictionary!["event"] as? String
        var departmentResponse = [String: AnyObject]()
        switch event! {
        case keyTaxMapCreate:
            departmentResponse["departmentId"] = responseDictionary!["departmentId"] as? Int
            departmentResponse["taxId"] = responseDictionary!["taxId"] as? Int
            return (ResponseCode.taxMapCreate, departmentResponse)
        case keyTaxMapDelete:
            departmentResponse["departmentId"] = responseDictionary!["departmentId"] as? Int
            departmentResponse["taxId"] = responseDictionary!["taxId"] as? Int
            return (ResponseCode.taxMapDelete, departmentResponse)
        case keyCreateDepartment, keyUpdateDepartment:
            departmentResponse["name"] = responseDictionary!["name"] as? String
            departmentResponse["itemsEbt"] = responseDictionary!["ebtItem"] as? Bool
            departmentResponse["id"] = responseDictionary!["id"] as? Int
            if let icon = responseDictionary!["glyph"] as! String? {
                let i = UInt32(strtoul(icon, nil, 16)) // to decimal
                departmentResponse["icon"] = String(Character(UnicodeScalar(i)))      // to char and string
            }
            departmentResponse["active"] = responseDictionary!["active"] as? Bool
            if event == keyCreateDepartment {
                return (ResponseCode.depCreate, departmentResponse)
            } else {
                return (ResponseCode.depUpdate, departmentResponse)
            }
        default: return (ResponseCode.fail, [String: AnyObject]())
        }
    }
    
}



/*
 
 [6/15/16, 12:39:07] Egor Yatsuk: active:true
 createdAt:"2015-11-03T01:01:33.000Z"
 ebtItem:true
 event:"departments:update"
 glyph:"f04c"
 hidden:true
 id:"3438"
 name:"Retail1"
 token:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiI0Mzk4ZTc3ZmRmNmQ2ODM5Y2E5NjJlYWI1MjdjMDY3MmRkYmY4MWM2NGE3OWYxM2VkYjExMGMwYzI1MTRjZDAwIiwiZXhwIjoxNDcwODM5ODc2MTM3fQ.S_U7qnGXLbSZlmhNrul7gc0EDWRJjYf6pJzT7UJeRo7orbD3zuTwEo_iHG2bw0CrZojBAen3r7FJpeFuCTBrNw"
 updatedAt:"2016-06-15T09:37:06.969Z"
 [6/15/16, 12:39:24] Egor Yatsuk: вот так выглядит сообщение на обновление модели департамента
 [6/15/16, 12:39:33] Egor Yatsuk: при создании то же самое
 [6/15/16, 12:39:42] Egor Yatsuk: толкьо event:"departments:create"
 
 
 [6/15/16, 12:42:47] Egor Yatsuk: такие же запросы надо отправлять в случае если ты обновляешь в селекте отношения между департментами и например Applied Taxes
 [6/15/16, 12:43:17] Egor Yatsuk: в таком случае ты шлешь вот такое сообщение
 'event': 'deptTaxMap:create',
 'departmentId': deptId,
 'taxId': taxId,
 'createdAt': moment().toISOString(),
 'updatedAt': moment().toISOString()
 [6/15/16, 12:43:37] Egor Yatsuk: или если удаляешь связь
 'event': 'deptTaxMap:delete',
 'departmentId': deptId,
 'taxId': taxId
 
 */