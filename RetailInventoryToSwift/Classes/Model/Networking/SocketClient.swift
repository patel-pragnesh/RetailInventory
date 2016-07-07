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
    case succes = 0, fail
}

class SocketClient {
    
    static let keyUpdateDepartment = "departments:update"
    static let keyCreateDepartment = "departments:create"
    static let keyTaxMapCreate = "deptTaxMap:create"
    static let keyTaxMapDelete = "deptTaxMap:delete"
    
    
    static var socket: SocketIOClient?
    static var failure: ((code: UInt, message: String) -> Void)?
    static var success: ((department: DepartmentTemplate) -> Void)?
    
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
            print (response)
            
            if response!["error"] != nil {
                if let errorContext = response!["error"] as? [String: AnyObject] {
                    failure?(code: errorContext["code"] as! UInt, message: errorContext["message"] as! String)
                    return
                }
            }
            let event = response!["event"] as? String
            var departmentResponse = DepartmentTemplate()
            switch event! {
            case keyTaxMapCreate:
                departmentResponse.id = response!["departmentId"] as? Int
            case keyTaxMapDelete:
                departmentResponse.id = response!["departmentId"] as? Int
            case keyCreateDepartment, keyUpdateDepartment:
                departmentResponse.name = response!["name"] as? String
                departmentResponse.itemsEbt = response!["ebtItem"] as? Bool
                departmentResponse.id = response!["id"] as? Int
                if let icon = response!["glyph"] as! String? {
                    let i = UInt32(strtoul(icon, nil, 16)) // to decimal
                    departmentResponse.icon = String(Character(UnicodeScalar(i)))      // to char and string
                }
                departmentResponse.active = response!["active"] as? Bool
            default: return
            }
            success?(department: departmentResponse)
        }
        
        socket?.on("command error") { data, ack in
            let response = (data[0] as! String).parseJSONString! as? [String: AnyObject]
            print (response)
            if response!["error"] != nil {
                if let errorContext = response!["error"] as? [String: AnyObject] {
                    failure?(code: errorContext["code"] as! UInt, message: errorContext["message"] as! String)
                }
            }
        }
    }
    
    static func updateDepartment(departmentTemplate: DepartmentTemplate, success: (department: DepartmentTemplate) -> Void, failure: (code: UInt, message: String) -> Void) {
        var department = departmentTemplate.asDictionaryForRequest()

        department["token"] = MyConstant.kUserToken
        
        var items = department
        items["event"] = keyUpdateDepartment
            
            self.success = success
        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static func createDepartment(departmentTemplate: DepartmentTemplate, success: (department: DepartmentTemplate) -> Void, failure: (code: UInt, message: String) -> Void) {
        var department = departmentTemplate.asDictionaryForRequest()
        
        department["token"] = MyConstant.kUserToken
        
        var items = department
        items["event"] = keyCreateDepartment
        
        self.success = success
        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static func taxMapCreate(taxId: Int, DepartmentId: Int, success: (department: DepartmentTemplate) -> Void, failure: (code: UInt, message: String) -> Void) {
        var tax = TaxTemplate.taxMapForRequest(taxId, depId: DepartmentId)
        
        tax["token"] = MyConstant.kUserToken
        
        var items = tax
        items["event"] = keyTaxMapCreate
        
        self.success = success
        self.failure = failure
        
        socket?.emit("command", items)
    }
    
    static func taxMapDelete(taxId: Int, DepartmentId: Int, success: (department: DepartmentTemplate) -> Void, failure: (code: UInt, message: String) -> Void) {
        var tax = TaxTemplate.taxMapForRequest(taxId, depId: DepartmentId)
        
        tax["token"] = MyConstant.kUserToken
        
        var items = tax
        items["event"] = keyTaxMapDelete
        
        self.success = success
        self.failure = failure
        
        socket?.emit("command", items)
    }
    
//    static func emitDepartment(departmentTemplate: DepartmentTemplate, taxId: NSNumber?, success: (department: DepartmentTemplate) -> Void, failure: (code: UInt, message: String) -> Void) {
//        var department = [String:AnyObject]()
//        
//        switch typeEmit {
//        case .create:
//            department["active"] = departmentTemplate.active
//            department["ebtItem"] = departmentTemplate.itemsEbt
//            department["name"] = departmentTemplate.name
//            if let icon = departmentTemplate.icon {
//                department["glyph"] = String((Int(icon))!, radix: 16)
//            }
//        case .update:
//            department["active"] = departmentTemplate.active
//            department["ebtItem"] = departmentTemplate.itemsEbt
//            department["name"] = departmentTemplate.name
//            department["id"] = departmentTemplate.id
//            if let icon = departmentTemplate.icon {
//                let ch = icon.unicodeScalars
//                department["glyph"] = String(ch[ch.startIndex].value, radix: 16)
//            }
//        case .taxMapCreate:
//            department["departmentId"] = departmentTemplate.id
//            department["taxId"] = taxId
//        case .taxMapDelete:
//            department["departmentId"] = departmentTemplate.id
//            department["taxId"] = taxId
//        }
//        
//        department["token"] = MyConstant.kUserToken
//        
//        var items = department
//        items["event"] = typeEmit.rawValue
//        
//        socket?.emit("command", items)
//        
//        socket?.on("command response") {data, ack in
//            let response = (data[0] as! String).parseJSONString! as? [String: AnyObject]
//            // let response = (data[0] as! AnyObject)
//            print (response)
//            if response!["error"] != nil {
//                if let errorContext = response!["error"] as? [String: AnyObject] {
//                    failure(code: errorContext["code"] as! UInt, message: errorContext["message"] as! String)
//                }
//            } else {
//                let event = response!["event"] as? String
//                var departmentResponse = DepartmentTemplate()
//                switch SocketEvent(rawValue: event!)! {
//                case .taxMapCreate:
//                    departmentResponse.id = response!["departmentId"] as? Int
//                case .taxMapDelete:
//                    departmentResponse.id = response!["departmentId"] as? Int
//                case .create, .update:
//                    departmentResponse.name = response!["name"] as? String
//                    departmentResponse.itemsEbt = response!["ebtItem"] as? Bool
//                    departmentResponse.id = response!["id"] as? Int
//                    if let icon = response!["glyph"] as! String? {
//                        let i = UInt32(strtoul(icon, nil, 16)) // to decimal
//                        departmentResponse.icon = String(Character(UnicodeScalar(i)))      // to char and string
//                    }
//                    departmentResponse.active = response!["active"] as? Bool
//                }
//                success(department: departmentResponse)
//            }
//        }
//    }
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