//
//  SocketClient.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 7/6/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation
import SocketIOClientSwift

class SocketClient {
    
    init {
        initSocket()
    }
    
    func initSocket() {
        socket = SocketIOClient(socketURL: NSURL(string: MyConstant.socketURL)!, options: [.Log(true), .ForcePolling(true)])
    }
    
    func create() {
        socket?.on("command response") {data, ack in
            let response = (data[0] as! String).parseJSONString
        }
        
            var items = department
            items["event"] = "departments:create"
            
            
            case "departments:update",
            "departments:create":
            
            socket?.emit("command", items)
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