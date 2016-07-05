//
//  UserMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class UserData: EntityMethods<User> {
    
    init() {
        let users = User.MR_findAllSortedBy("userID", ascending: true) as! [User]
        super.init(array: users)
    }
    
    func addObject() -> User {
        let newUser = User.MR_createEntity()!
        array.append(newUser)
        return newUser
    }
    
    func removeObject(user: User) {
        user.MR_deleteEntity()
    }
    
    func editObject(old: User, new: User) -> Bool {
        let index = array.indexOf(old)
        if index != nil {
            array[index!] = new
            return true
        } else {
            return false
        }
    }
}