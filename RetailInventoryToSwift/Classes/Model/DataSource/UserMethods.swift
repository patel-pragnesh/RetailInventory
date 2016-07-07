//
//  UserMethods.swift
//  RetailInventoryToSwift
//
//  Created by Sak, Andrey2 on 6/20/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import Foundation

class UserMethods: EntityMethods<User> {
    
    init() {
        let users = User.MR_findAllSortedBy("userID", ascending: true) as! [User]
        super.init(array: users)
    }
}