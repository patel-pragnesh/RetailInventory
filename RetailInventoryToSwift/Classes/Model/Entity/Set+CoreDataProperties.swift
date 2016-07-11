//
//  Set+CoreDataProperties.swift
//  RetailInventorySwift
//
//  Created by Sak, Andrey2 on 7/11/16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Set {

    @NSManaged var active: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var manyPer: NSNumber?
    @NSManaged var max: NSNumber?
    @NSManaged var name: String?
    @NSManaged var item: NSSet?

}
